load App.root.join 'db_connection.rb'
@view = View.new
@view.extend Display
@view.extend Timer
def confirm?(msg, default: true)
  Ask.confirm "#{msg}?", default: default
end

def checkup
  case Ask.list '何をしますか？', %w(選出 タイマー 音声 最近の話し手)
  when 0 then nominate(dryrun: true)
  when 1 then @view.timer
  when 2 then Notify.say 'time’s up'
  when 3 then @view.show_last_speeches
  end
  0
end

def nominate(dryrun: false)
  App.logger.debug "候補: #{App.dbm.select_member_without([]).map(&:last).join(', ')}"
  puts '下記の二人が選出から外れます'
  @view.show_last_speeches
  return unless confirm?('よろしいですか')
  member = App.dbm.select_member_without(App.dbm.last_speeches.map(&:first))
  sieve_candidates!(member) if confirm?('追加除外', default: false)
  App.logger.info "候補: #{member.map(&:last).join(', ')}"

  @view.animate_progress
  member = member.sample
  puts `cowsay #{member[1]}`
  Notify.say member[1]
  App.dbm.update_speech(member[0], Date.today.to_s) unless dryrun
  @view.timer if confirm?('タイマーを使用しますか')
end

def sieve_candidates!(candidate_pairs)
  checks = Ask.checkbox '除外されます', candidate_pairs.map(&:last)
  checks.zip(candidate_pairs.map(&:first)).select(&:first).map(&:last)
end

exit checkup if @option[:checkup]
choices = %w( 終了 自動選出 全履歴 個人の履歴 メンバー追加 メンバー削除 )
loop do
  @view.show_members
  case Ask.list '何をしますか？', choices
  when 0 then exit
  when 1 then nominate
  when 2 then @view.show_all_speeches
  when 3 then App.dbm.history    Ask.input '名前を入力してください'
  when 4 then App.dbm.user_entry Ask.input '名前を入力してください'
  when 5
    @view.show_members
    App.dbm.user_delete Ask.input 'ユーザIDを入力してください'
  end
end
