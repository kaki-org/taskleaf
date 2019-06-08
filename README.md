# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* その他

erbではなくslimを使う為にhtml2slimを使用。デフォルトのerbファイルは以下のコマンドで変換済み
```
bundle exec erb2slim app/views/layouts/ --delete
```
