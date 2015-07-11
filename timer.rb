require_relative 'say'
require 'io/console'
def timer
	t = Time.new(0,1,1,0,3)
  180.times do |argv|
    sleep(1)
    t -= 1
		print "\n" * (STDOUT.winsize[0] - Artii::Base.new.asciify("3:00").count("\n"))
		puts Artii::Base.new.asciify t.strftime("%M:%S")
  end
	App::Say.timeup
end
