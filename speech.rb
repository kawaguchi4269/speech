ENV['TZ'] = 'Asia/Tokyo'
class DatabaseManagement
  require 'sqlite3'
  require 'rubygems'
  require 'artii'
	require "io/console"


  def initialize
    unless File.exist?("speech.db")
      @db = SQLite3::Database.new("speech.db")
      sql = <<-SQL
      CREATE TABLE users (
        id integer PRIMARY KEY AUTOINCREMENT,
        name text NOT NULL UNIQUE
        );
      CREATE TABLE speeches (
        id integer PRIMARY KEY AUTOINCREMENT,
        user_id integer,
        speech_at text
        );
      SQL
      @db.execute_batch(sql)
    end
    @db = SQLite3::Database.new("speech.db")
  end

  def user_entry(name)
    @db.execute("INSERT INTO users (name) VALUES('#{name}')")
  end

	def user_delete(id)
		@db.execute("DELETE FROM users WHERE id = (#{id})")
	end

  def update_speech(user_id, speech_at)
    @db.execute("INSERT INTO speeches (user_id, speech_at) VALUES('#{user_id}','#{speech_at}')")
  end

  def select_member(reject_ids)
    ids = @db.execute("SELECT id FROM users")
    if reject_ids.size > 0
      reject_ids = reject_ids.split.map do |reject_id|
        reject_id.to_i
      end
      ids = ids.flatten - reject_ids
    end
    member = @db.execute("SELECT id, name FROM users WHERE users.id IN (#{ids.join(",")})")
  end

  def history(name)
    sql = <<-"SQL"
      SELECT speeches.speech_at
      FROM users LEFT JOIN speeches ON users.id = speeches.user_id
      WHERE users.name = "#{name}"
      SQL
    count = 0
    speeches = @db.execute(sql) { |speech_at|
      puts "日付 : #{speech_at.join}"
      count += 1
    }
    puts " "
    puts "#{name} さんの朝礼の回数は#{count} 回です。"
  end
end

def show_member(db)
  db.execute("SELECT * FROM users") { |id, name|
    puts "#{id} | #{name}"
  }
end

def show_all_speeches(db)
  db.execute("SELECT * FROM speeches") { |id, user_id, speech_at|
    puts "#{id} | #{user_id} | #{speech_at}"
  }
end

def timer
	t = Time.new(0,1,1,0,3)
  180.times do |argv|
    sleep(1)
    t -= 1
		print "\n" * (STDOUT.winsize[0] - Artii::Base.new.asciify("3:00").count("\n"))
		puts Artii::Base.new.asciify t.strftime("%M:%S")
  end
  `say -v Allison "time up"`
end



dbm = DatabaseManagement.new
db = SQLite3::Database.new("speech.db")

loop do
  puts "何をしますか？"
  print "1 選出 2 履歴 3 個人の履歴 8 メンバー追加 9 メンバー削除 0 終了"
  select = gets.to_i
  case select
  when 1
    show_member(db)
    puts "朝礼の対象から外す人のIDをスペース区切りで入力してください"
    print "例 | 1 3 5 : "
    ids = gets.to_s.chomp
    member = dbm.select_member(ids)
    sleep(1)
    member = member.sample
    puts member[1]
		`say -v Allison #{member[1]}`
    dbm.update_speech(member[0], Time.now.strftime("%Y-%m-%d"))
    puts "タイマーを使用しますか？ : y/n"
    select = gets.chomp
    timer if select == "y"
  when 2
		puts "member".center(20, "-")
		show_member(db)
		puts "speeches".center(20, "-")
		show_all_speeches(db)
  when 3
    print "名前を入力してください : "
    name = gets.to_s.chomp
		puts "speeches".center(20, "-")
    dbm.history(name)
  when 8
    name = gets.to_s.chomp
    dbm.user_entry(name)
	when 9
		show_member(db)
		print "削除したいユーザーのIDを入力してください : "
		id = gets.chomp
		dbm.user_delete(id)
	when 99
		timer
	when 999
		`say -v Allison "time up"`
 	when 0
    exit
  end
end



