class DatabaseManagement
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
