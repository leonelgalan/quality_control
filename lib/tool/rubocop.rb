class Tool::Rubocop < Tool::Base
  parse_output

  def self.command
    'rubocop --format json'
  end
end
