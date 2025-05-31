# Junie利用のガイドライン

## ルール

- 回答は全て日本語で行うこと
- プランニングの過程も日本語で出力すること

## Taskleaf 開発ガイドライン

このドキュメントは、Taskleafプロジェクトの開発と保守のためのガイドラインと手順を提供します。

### ビルド/設定手順

#### ローカル開発環境

##### オプション1: Dockerを使用する（推奨）

1. **初期セットアップ**:
   ```bash
   make init
   ```
   これによりDockerコンテナがビルドされ、セットアップスクリプトが実行されます。

2. **アプリケーションの起動**:
   ```bash
   make up
   ```
   これにより、必要なすべてのサービス（web、PostgreSQL、Redisなど）が起動します。

3. **Railsコンソールの実行**:
   ```bash
   make c
   ```

4. **データベースのリセット**:
   ```bash
   make reset
   ```

##### オプション2: Dockerを使用しない場合

READMEにも記載されているように、Dockerを使用せずにアプリケーションを実行することもできます：

1. **環境変数の設定**:
   ```bash
   # .envrc
   export PGSQL_HOST=pgsql.lvh.me
   export DYLD_LIBRARY_PATH=$(brew --prefix postgresql@14)/lib/postgresql@14
   export REDIS_URL='redis://redis.lvh.me:16379'
   ```

2. **データベースとRedisの起動**:
   ```bash
   docker compose up -d db redis
   ```

3. **初期セットアップ**:
   ```bash
   bin/setup
   ```

4. **Railsサーバーの起動**:
   ```bash
   bundle exec rails s
   ```

#### Dipの使用

このプロジェクトは、より合理的なDockerワークフローのために[Dip](https://github.com/bibendi/dip)もサポートしています：

```bash
# Provision the environment
dip provision

# Run the Rails server
dip rails s

# Run the Rails console
dip rails c

# Run RSpec tests
dip rspec
```

### テスト情報

#### テストフレームワーク

このプロジェクトでは、以下のコンポーネントを含むRSpecをテストに使用しています：
- Rails統合のためのRSpec Rails
- システム/統合テスト用のCapybaraとPlaywright
- テストデータ生成のためのFactoryBot
- 簡略化されたテストアサーション用のShoulda Matchers
- メールテスト用のEmailSpec

#### テストの実行

##### Dockerを使用する場合：

```bash
# すべてのテストを実行
make rspec

# 特定のテストを実行
make rspec ARG="spec/models/task_spec.rb"

# 特定のフォーマットでテストを実行
make rspec ARG="spec/models/task_spec.rb -f d"
```

##### Dipを使用する場合：

```bash
# すべてのテストを実行
dip rspec

# 特定のテストを実行
dip rspec spec/models/task_spec.rb
```

#### Guardを使用した継続的テスト

このプロジェクトは継続的テストのためにGuardをサポートしています：

```bash
make guard
```

これにより、ファイルの変更を監視し、関連するテストが自動的に実行されます。

#### テストの作成

##### モデルテスト

以下はTaskモデルのテスト例です：

```ruby
# spec/models/task_display_spec.rb
require 'rails_helper'

RSpec.describe Task, 'display methods' do
  describe '#display_name' do
    context 'when name is shorter than 20 characters' do
      let(:task) { build(:task, name: 'Short name') }

      it 'returns the full name' do
        expect(task.display_name).to eq('Short name')
      end
    end

    context 'when name is longer than 20 characters' do
      let(:task) { build(:task, name: 'This is a very long task name that should be truncated') }

      it 'returns the truncated name with ellipsis' do
        expect(task.display_name).to eq('This is a very long...')
      end
    end
  end
end
```

##### System Tests

System testsはCapybaraとPlaywrightを使用します。以下は例です：

```ruby
# spec/system/logins_spec.rb
require 'rails_helper'

describe 'ログイン機能', :js do
  let(:user) { create(:user, name: 'ユーザA', email: 'a@example.com') }

  context '正しいユーザ名とパスワードを入力したとき' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
    end

    it 'トップ画面に遷移する' do
      click_link_or_button 'ログインする'
      expect(page).to have_current_path root_path
    end
  end
end
```

#### メールテスト

このプロジェクトはメールテスト用にmailcatcherを使用しています。以下のURLでmailcatcherインターフェースにアクセスできます：

```
http://lvh.me:50080
```

### 追加の開発情報

#### コードスタイル

このプロジェクトは、以下のプラグインを含むコードスタイル強制のためにRuboCopを使用しています：
- RSpec固有のルールのためのrubocop-rspec
- Rails固有のルールのためのrubocop-rails

注目すべき設定：
- 非ASCII文字のコメント（日本語テキスト用）を許可
- スペックのためのブロック長制限の緩和
- 日本語パターンを含むRSpec用の特別なコンテキスト表現パターン
- 最大行長は190文字

RuboCopを実行するには：

```bash
make rubocop

# Or with specific arguments
make rubocop ARG="--auto-correct"
```

#### 国際化

アプリケーションは日本語を主要言語として国際化をサポートしています。RSpecテストには、異なるロケールでのテスト例が含まれています。

#### データベース

このプロジェクトはデータベースとしてPostgreSQL 17.5を使用しています。スキーマにはタスク、ユーザー、連絡先、およびActive Storageのテーブルが含まれています。

#### バックグラウンド処理

このプロジェクトはバックグラウンドジョブ処理のためにRedisを使用したSidekiqを使用しています。

#### フロントエンド

このプロジェクトは以下を使用しています：
- UIコンポーネント用のBootstrap
- テンプレート用のSlim（ERBから変換）
- cssbundling-railsによるCSSバンドル
- jsbundling-railsによるJavaScriptバンドル
- フロントエンドのインタラクティブ性のためのHotwire（TurboとStimulus）

### モジュラーモノリス

このプロジェクトは以下を使用したモジュラーモノリスとして構成されています：
- packs-rails
- packwerk
- packwerk-extensions

これにより、アプリケーションの成長に伴って、より良いコード編成と保守性が可能になります。
