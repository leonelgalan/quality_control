class Tool::Brakeman < Tool::Base
  json_parse_output

  def self.command
    'brakeman --quiet --format=json'
  end
end
