class RepoAnalizer
  def initialize(oauth_token, repo, ref = 'master')
    @oauth_token = oauth_token
    @repo = repo
    @ref = ref

    @archive = "#{repo.parameterize}.tar.gz"
  end

  def run(tools = %i(rubocop flog flay brakeman reek))
    download_code_temporarily do
      run_tools(tools)
    end

    @output
  end

  private

  def download_code_temporarily
    download
    read_folder
    untar
    yield
    delete
  end

  def client
    @client ||= Octokit::Client.new(access_token: @oauth_token)
  end

  def archive_link
    client.archive_link @repo, ref: @ref
  end

  def tool_class(tool)
    "Tool::#{tool.to_s.capitalize}".constantize
  rescue
    raise NotImplementedError, "#{tool} hasn't been implemented"
  end

  def download
    # -s, --silent Silent or quiet mode. Don't show progress meter or error
    #              messages.  Makes Curl mute. It will still output the data you
    #              ask for, potentially even to the terminal/stdout unless you
    #              redirect it.
    `curl --silent #{archive_link} > #{@archive}`
  end

  def read_folder
    # -t      List archive contents to stdout.
    # -f file Read the archive from or write the archive to the specified file.
    @folder = `tar -tf #{@archive} | head -n 1`.strip
  end

  def untar
    # -x      Extract to disk from the archive.  If a file with the same name
    #         appears more than once in the archive, each copy will be
    #         extracted, with later copies overwriting (replacing) earlier
    #         copies.
    # -f file Read the archive from or write the archive to the specified file.
    `tar -xf #{@archive}`
  end

  def run_tools(tools)
    @output = tools.each_with_object({}) do |tool, memo|
      memo[tool] = tool_class(tool).run(@folder)
      memo
    end
  end

  def delete
    `
      rm #{@archive}
      rm -rf #{@folder}
    `
  end
end
