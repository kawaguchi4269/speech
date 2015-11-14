class View
  def initialize
    @db = SQLite3::Database.new(App.settings[:db_name])
    @speeches = Arel::Table.new(:speeches)
    @users = Arel::Table.new(:users)
  end
  attr_reader :speeches, :users

  def show_members
    puts 'member'.center(20, '-')
    @db.execute('SELECT * FROM users') do |id, name|
      puts "#{id} | #{name}"
    end
  end

  def show_all_speeches
    puts 'speeches'.center(20, '-')
    sql = <<-"SQL"
        SELECT user_id, speech_at, name
        FROM speeches LEFT JOIN users ON users.id = speeches.user_id
        SQL
    @db.execute(sql) do |user_id, speech_at, name|
      puts "#{user_id} | #{speech_at} | #{name}"
    end
  end

  def show_last_speeches
    puts 'speeches'.center(20, '-')
    App.dbm.last_speeches.reverse_each do |user_id, name|
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
