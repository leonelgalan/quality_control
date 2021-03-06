class Tool::Base
  def self.parse_output
    @parse = true
  end

  def self.run(folder)
    output = `cd #{folder} && #{command}`
    output = parse(output) if @parse
    output
  end

  def self.parse(output)
    JSON.parse(output)
  rescue JSON::ParserError
    {}
  end

  def self.command
    fail NotImplementedError, "#{self.class.name} doesn't implement #command"
  end
end
