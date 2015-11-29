require_relative 'timer'
load App.root.join 'db_connection.rb'
@view = View.new
extend Display

def confirm?(msg, default: true)
  Ask.confirm "#{msg}?", default: default
end

def debug(type)
  case type
  when 'test'
    puts '選出テスト'.center(20, '-')
    plain_nominate(dryrun: true)
  when 'timer'
    puts 'タイマーテスト'.center(20, '-')
    timer
  when 'mic'
    puts 'マイクテスト'.center(20, '-')
    Notify.say 'time up'
  when 'last'
    @view.show_last_speeches
  else
    puts "#{%w( test timer mic last ).join(', ')} are available"
    return 1
  end
  0
end

def nominate
  STDERR.puts "[DEB] 候補: #{App.dbm.select_member_without([]).map(&:last).join(', ')} \n\n" if $DEBUG
  puts '下記の二人が選出から外れます'
  @view.show_last_speeches
  return unless confirm?('よろしいですか')
  member = App.dbm.select_member_without(App.dbm.last_speeches.map(&:first))
  STDERR.puts "[DEB] 候補: #{member.map(&:last).join(', ')} \n\n" if $DEBUG
  sieve_candidates!(member) if confirm?('追加除外', default: false)
  STDERR.puts "[DEB] 候補: #{member.map(&:last).join(', ')} \n\n" if $DEBUG

  animate_progress
  member = member.sample
  puts `cowsay #{member[1]}`
  Notify.say member[1]
  App.dbm.update_speech(member[0], Time.now.strftime('%Y-%m-%d'))
  timer if confirm?('タイマーを使用しますか')
end

def sieve_candidates!(candidate_pairs)
  checks = Ask.checkbox '除外されます', candidate_pairs.map(&:last)
  checks.zip(candidate_pairs.map(&:first)).select(&:first).map(&:last)
end

def plain_nominate(dryrun: nil)
  @view.show_members
  puts '朝礼の対象から外す人のIDをスペース区切りで入力してください'
  print '例 | 1 3 5 : '
  ids = gets.to_s.chomp
  member = App.dbm.select_member_without(ids)
  sleep(1)
  member = member.sample
  puts member[1]
  Notify.say member[1]
  App.dbm.update_speech(member[0], Date.today.to_s) unless dryrun
  timer if confirm?('タイマーを使用しますか')
end

def prompt_mode(choices)
  Ask.list '何をしますか？', choices
end
exit debug(@option[:debug]) if @option[:debug]
choices = %w( 終了 自動選出 全履歴 個人の履歴 選出 メンバー追加 メンバー削除 )
loop do
  @view.show_members
  case prompt_mode choices
  when 0 then exit
  when 1 then nominate
  when 2 then @view.show_all_speeches
  when 3
    print '名前を入力してください: '
    name = gets.to_s.chomp
    App.dbm.history(name)
  when 4 then plain_nominate
  when 5
    name = gets.to_s.chomp
    App.dbm.user_entry(name)
  when 6
    @view.show_members
    print '削除したいユーザーのIDを入力してください: '
    id = gets.chomp
    App.dbm.user_delete(id)
  end
end
