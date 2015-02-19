class Tool::Brakeman < Tool::Base
  parse_output

  def self.command
    'brakeman --quiet --format=json'
  end
end
