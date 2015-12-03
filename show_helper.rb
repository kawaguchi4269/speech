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

class View
  include Display
  include Timer
  def show(method)
    puts send(method).map { |c| c.join ' | ' }.join("\n")
  end

  private

  def members
    Employee.all.each_with_object([]) do |employee, m|
      m << [employee.id.to_s.ljust(2), employee.name]
    end
  end

  def all_speeches
    Speech.all.each_with_object([]) do |speech, m|
      m << [speech.employee_id.to_s.ljust(2), speech.speech_at, speech.employee.name]
    end
  end

  def last_speeches
    Speech.last(2).each_with_object([]) do |speech, m|
      m << [speech.employee_id, speech.employee.name]
    end
  end
end

module Notify
  def self.say(arg)
    puts Cowsay::Character::Cow.say arg
    `say -v Allison #{arg}`
  rescue Errno::ENOENT
    nil
  end
end
