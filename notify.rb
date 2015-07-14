module Notify
  def self.say(arg)
    `say -v Allison #{arg}`
  rescue Errno::ENOENT
    puts `cowsay #{arg}`
  end
end
