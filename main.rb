require_relative 'timer'
load App.root.join 'db_connection.rb'
dbm, db = App.dbm, App.db
loop do
  puts "何をしますか？"
  print "1 選出 2 自動選出 3 全履歴 4 個人の履歴 8 メンバー追加 9 メンバー削除 0 終了"
  select = gets.to_s.chomp
  case select
  when "1"
    show_member(db)
    puts "朝礼の対象から外す人のIDをスペース区切りで入力してください"
    print "例 | 1 3 5 : "
    ids = gets.to_s.chomp
    member = dbm.select_member(ids)
    sleep(1)
    member = member.sample
    puts member[1]
    Notify.say member[1]
    dbm.update_speech(member[0], Time.now.strftime("%Y-%m-%d"))
    puts "タイマーを使用しますか？ : y/n"
    select = gets.chomp
    timer if select == "y"
  when "2"
    puts "下記の二人が選出から外れます"
    show_last_speeches(db)
    puts "よろしいですか？ : y/n"
    select = gets.chomp
    if select == "y" then
      ids = dbm.last_speeches
      member = dbm.select_member(ids)
      sleep(1)
      member = member.sample
      puts member[1]
      Notify.say member[1]
      dbm.update_speech(member[0], Time.now.strftime("%Y-%m-%d"))
      puts "タイマーを使用しますか？ : y/n"
      select = gets.chomp
      timer if select == "y"
    end
  when "3"
    show_all_speeches(db)
  when "4"
    print "名前を入力してください : "
    name = gets.to_s.chomp
    dbm.history(name)
  when "8"
    name = gets.to_s.chomp
    dbm.user_entry(name)
  when "9"
    show_member(db)
    print "削除したいユーザーのIDを入力してください : "
    id = gets.chomp
    dbm.user_delete(id)
  when "test"
    show_member(db)
    puts "選出テスト".center(20, "-")
    puts "朝礼の対象から外す人のIDをスペース区切りで入力してください"
    print "例 | 1 3 5 : "
    ids = gets.to_s.chomp
    member = dbm.select_member(ids)
    sleep(1)
    member = member.sample
    puts member[1]
    Notify.say member[1]
    dbm.update_speech(member[0], Time.now.strftime("%Y-%m-%d"))
    puts "タイマーを使用しますか？ : y/n"
    select = gets.chomp
    timer if select == "y"
  when "timer"
    puts "タイマーテスト".center(20, "-")
    timer
  when "mic"
    puts "マイクテスト".center(20, "-")
    Notify.say 'time up'
  when "last"
    show_last_speeches(db)
  when "0"
    exit
  end
end
