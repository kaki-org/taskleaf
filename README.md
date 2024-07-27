# README

## 概要

<https://taskleaf-spc0.onrender.com/>

[現場で使える Ruby on Rails 5速習実践ガイド](https://book.mynavi.jp/ec/products/detail/id=93905)の成果物をどんどんアップデートしていく学習用リポジトリ。
タスク管理サイト。

## Stack

[![codecov](https://codecov.io/gh/kakikubo/taskleaf/graph/badge.svg?token=JXU7YSO6G1)](https://codecov.io/gh/kakikubo/taskleaf)
[![Ruby](https://img.shields.io/badge/ruby-3.3.4-blue.svg)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/rails-7.1.1-blue.svg)](https://rubyonrails.org/)
[![Redis](https://img.shields.io/badge/redis-7.2.1-blue.svg)](https://github.com/docker-library/redis)
[![PostgreSQL](https://img.shields.io/badge/postgresql-16.2-blue.svg)](https://www.postgresql.org)

## Environments

- PaaS <https://render.com>
- DaaS <https://supabase.io>

PaaSとして<render.com>を、さらにDaaSとして<supabase.io>を使っている。
masterにマージする事でデプロイが走るようになっている。

## ローカル開発環境の整備

Dockerを使わない場合は以下の通り

```bash
# .envrc
export PGSQL_HOST=pgsql.lvh.me
export DYLD_LIBRARY_PATH=$(brew --prefix postgresql@14)/lib/postgresql@14
export REDIS_URL='redis://redis.lvh.me:16379'
```

dbとredisは起動しておく

```bash
docker compose up -d db redis
```

初回は`bin/setup`を叩く

```bash
bin/setup
```

起動してみる

```bash
bundle exec rails s
```

rubymineの場合は環境変数に以下を指定しておく

```plain
REDIS_PORT=16379;PGSQL_HOST=pgsql.lvh.me
```

## その他

erbではなくslimを使う為にhtml2slimを使用。デフォルトのerbファイルは以下のコマンドで変換済み

```bash
bundle exec erb2slim app/views/layouts/ --delete
```

## rspecのインストール

```bash
bundle
bin/rails g rspec:install
```

テストを実行するサンプル

```bash
bundle exec rspec --dry-run spec/system/tasks_spec.rb -f d
```

## sandboxモード

`-s`をつけるとsandboxモードで起動出来る。DBの変更はすべてロールバックされる

```bash
kakikubo@kair ~/Documents/learning-rails/taskleaf % bin/rails c -s
Running via Spring preloader in process 2985
Loading development environment in sandbox (Rails 5.2.3)
Any modifications you make will be rolled back on exit
irb(main):001:0> user = User.first
  User Load (0.5ms)  SELECT  "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT $1  [["LIMIT", 1]]
=> #<User id: 1, name: "匿名", email: "user@examle.com", password_digest: "digest", created_at: "2019-06-09 11:17:56", updated_at: "2019-06-09 11:17:56", admin: false>
irb(main):002:0> task = user.tasks.new(name:'')
=> #<Task id: nil, name: "", description: nil, created_at: nil, updated_at: nil, user_id: 1>
irb(main):003:0> task.valid?
=> true
irb(main):004:0> #ここでCtrl-Dを押してexitする
   (0.5ms)  ROLLBACK
kakikubo@kair ~/Documents/learning-rails/taskleaf %
```

## mail送信テスト

mailcatcher用のコンテナを起動しているので、

<http://lvh.me:50080>

で参照できます。

※ [参考リンク](https://qiita.com/pocari/items/de0436c39ffc65647cf0)

## kaminari

paginationでkaminariを使用している。スタイルを適用するために以下を実行してます。

```bash
bin/rails g kaminari:views bootstrap4
```

## guard-rspec

```bash
make guard
```

したあとでテストファイルを編集していると自動でテスト実行を再開してくれる

## dip

dipも取り込んでみた。以下のように使う

```bash
dip rails s
```
