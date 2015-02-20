class Tool::Reek < Tool::Base
  parse_output

  def self.command
    'reek . --format yaml'
  end

  def self.parse(output)
    { result: YAML.parse(output).to_ruby }
  rescue Psych::SyntaxError
    {}
  end
end
