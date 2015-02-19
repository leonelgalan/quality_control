class Tool::Rubocop < Tool::Base
  json_parse_output

  def self.command
    'rubocop . --format json'
  end
end
