def show_member(db)
  puts "member".center(20, "-")
  db.execute("SELECT * FROM users") do |id, name|
    puts "#{id} | #{name}"
  end
end

def show_all_speeches(db)
  puts "speeches".center(20, "-")
  sql = <<-"SQL"
      SELECT user_id, speech_at, name
      FROM speeches LEFT JOIN users ON users.id = speeches.user_id
      SQL
  db.execute(sql) do |user_id, speech_at, name|
    puts "#{user_id} | #{speech_at} | #{name}"
  end
end

def show_last_speeches(db)
  puts "speeches".center(20, "-")
  sql = <<-"SQL"
      SELECT user_id, name
      FROM speeches LEFT JOIN users ON users.id = speeches.user_id
      ORDER BY speeches.id DESC LIMIT 2
      SQL
  db.execute(sql).reverse.each do |user_id, name|
    puts "#{user_id} | #{name}"
  end
end
