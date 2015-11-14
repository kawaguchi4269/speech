class DatabaseManagement
  def initialize
    unless File.exist?('speech.db')
      @db = SQLite3::Database.new('speech.db')
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

    @speeches = Arel::Table.new(:speeches)
    @users = Arel::Table.new(:users)
    @db = SQLite3::Database.new(App.settings[:db_name])
  end
  attr_reader :speeches, :users

  def users_from(ids)
    @db.execute users.project(:name).where(users[:id].in(ids)).to_sql
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

  def select_member_without(reject_ids)
    ids = @db.execute('SELECT id FROM users').flatten - reject_ids
    member = @db.execute(
      "SELECT id, name FROM users WHERE users.id IN (#{ids.join(',')})")
    fail 'だれもいない' if member.empty?
    if member.any? { |e| e.last.empty? }
      STDERR.puts "[WARN] 変な値 #{member.select { |e| e.last.empty? }}"
      # FIXME
      member.delete_if { |e| e.last.empty? }
    end
    member
  end

  def _last_speeches
    sql = <<-"SQL"
      SELECT user_id, name
      FROM speeches LEFT JOIN users ON users.id = speeches.user_id
      ORDER BY speeches.id DESC LIMIT 2
      SQL
    @db.execute(sql)
  end

  def last_speeches
    sql = speeches
          .project(:user_id, :name)
          .join(users)
          .on(speeches[:user_id].eq(users[:id]))
          .order(speeches[:speech_at].desc)
          .take(2).to_sql
    @db.execute(sql)
  end

  def history(name)
    sql = <<-"SQL"
      SELECT speeches.speech_at
      FROM users LEFT JOIN speeches ON users.id = speeches.user_id
      WHERE users.name = "#{name}"
      SQL
    count = 0
    puts 'speeches'.center(20, '-')
    _speeches = @db.execute(sql) do |speech_at|
      puts "日付 : #{speech_at.join}"
      count += 1
    end
    puts ' '
    puts "#{name} さんの朝礼の回数は#{count} 回です。"
  end
end
