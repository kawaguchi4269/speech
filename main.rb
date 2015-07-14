require_relative 'timer'
load App.root.join 'db_connection.rb'
dbm, db = App.dbm, App.db
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
  	Notify.say member[1]
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
  	Notify.say 'time up'
 	when 0
    exit
  end
end
