class View
  def initialize
    @dbm = App.dbm
  end

  def show_members
    puts 'member'.center(20, '-')
    @dbm.users_all do |id, name|
      puts "#{id} | #{name}"
    end
  end

  def show_all_speeches
    puts 'speeches'.center(20, '-')
    @dbm.speeches_all do |user_id, speech_at, name|
      puts "#{user_id} | #{speech_at} | #{name}"
    end
  end

  def show_last_speeches
    puts 'speeches'.center(20, '-')
    @dbm.last_speeches.reverse_each do |user_id, name|
      puts "#{user_id} | #{name}"
    end
  end
end

class String # :nodoc:
  def frame
    print slice 0
    sleep 0.05
    print "\b"
  end
end

# Adds visual effects
module Display
  def animate_progress(t = 5)
    print '.' * t
    t.times do
      print "\b"
      ['/', '-', '\\', '|', ' '].each(&:frame)
    end
    puts
  end
end

module Notify
  def self.say(arg)
    `say -v Allison #{arg}`
  rescue Errno::ENOENT
    puts `cowsay #{arg}`
  end
end

require 'io/console'
module Timer
  def timer
    t = Time.new(0, 1, 1, 0, 3)
    180.times do |_argv|
      sleep(1)
      t -= 1
      print "\n" * (STDOUT.winsize[0] - Artii::Base.new.asciify('3:00').count("\n"))
      puts Artii::Base.new.asciify t.strftime('%M:%S')
    end
    Notify.say 'time’s up'
  end
end
