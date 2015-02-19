class Tool::Flog < Tool::Base
  def self.command
    'flog -ae . 2>/dev/null'
  end
end
