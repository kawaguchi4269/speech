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
