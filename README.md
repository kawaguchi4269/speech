# speech
会社の朝礼用に作成しました〜
macでの使用を前提にしてるのでsayコマンドとか使ってます

# Getting Started
```
rake migrate
ruby db/seeds.rb
ruby speech.rb 2> /dev/null
```

# Debug
## Checkup
```
ruby speech.rb -c
```
## Timecop scaling
```
ruby -d speech.rb
```
