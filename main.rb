@view = View.new
def confirm?(msg, default: true)
  Ask.confirm "#{msg}?", default: default
end

def checkup
  case Ask.list '何をしますか？', %w(選出 タイマー 音声 最近の話し手)
  when 0 then nominate(dryrun: true)
  when 1 then @view.timer
  when 2 then Notify.say 'time’s up'
  when 3 then @view.show :last_speeches
  end
  0
end

def nominate(dryrun: false)
  puts '下記の二人が選出から外れます'
  @view.show :last_speeches
  employees = if confirm?('よろしいですか')
                ids = Speech.last(2).map(&:employee_id)
                employees = Employee.where.not(id: ids)
                if confirm?('追加除外', default: false) then sieve_candidates(employees)
                else employees
                end
              else
                candidates = Employee.all
                checks = Ask.checkbox '対象を選んでください', candidates.map(&:name),
                                      default: [true].cycle(Employee.count).to_a
                checks.zip(candidates).select(&:first).map(&:last)
              end

  @view.animate_progress
  nominated = employees.sample
  Notify.say nominated.name
  Speech.create(employee: nominated, speech_at: Time.now) unless dryrun
  @view.timer if confirm?('タイマーを使用しますか')
end

def sieve_candidates(candidates)
  checks = Ask.checkbox '除外されます', candidates.map(&:name)
  checks.zip(candidates).reject(&:first).map(&:last)
end

exit checkup if @option[:checkup]
choices = %w( 終了 選出 全履歴 個人の履歴 メンバー追加 メンバー削除 )
loop do
  puts '#' * 25
  @view.show :members
  case Ask.list '何をしますか？', choices
  when 0 then exit
  when 1 then nominate
  when 2 then @view.show :all_speeches
  when 3
    employee = Employee.find_by name: Ask.input('名前を入力してください')
    next unless employee
    employee.speeches.each { |speech| puts "日付: #{speech.speech_at}" }
    puts "#{employee.name}さんのスピーチ回数は#{employee.speeches.count}回です。"
  when 4
    Employee.create name: Ask.input('名前を入力してください')
  when 5
    employee = Employee.find Ask.input '削除したいユーザーのIDを入力してください'
    employee.destroy if employee
  end
end
