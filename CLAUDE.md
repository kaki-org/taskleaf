# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリのコードで作業する際のガイダンスを提供します。

## プロジェクト概要

TaskleafはRuby on Rails 7.2とPostgreSQLで構築されたタスク管理Webアプリケーションです。「現場で使える Ruby on Rails 5速習実践ガイド」をベースとした学習プロジェクトで、継続的にアップデートされています。このアプリケーションは、ユーザー認証、タスクのCRUD操作、CSV インポート/エクスポート、およびメール通知をサポートしています。

## 開発コマンド

### ローカル開発（Dockerなし）
```bash
# 初期セットアップ
bin/setup

# 開発サーバーの起動
bundle exec rails server

# データベース操作
bundle exec rails db:migrate
bundle exec rails db:reset
bundle exec rails db:seed

# アセットコンパイル
bun run build:css
bun run watch:css
```

### Docker開発
```bash
# プロジェクト初期化
make init

# 全サービス起動
make up

# コンソールアクセス
make c

# テスト実行
make rspec
# または引数付きで
make rspec ARG="spec/models/task_spec.rb"

# リンティング
make rubocop

# テスト監視
make guard
```

### テスト
```bash
# 全テスト実行
bundle exec rspec

# 特定のテストファイルを実行
bundle exec rspec spec/models/task_spec.rb

# ドキュメント形式で実行
bundle exec rspec --format documentation

# カバレッジレポート生成（coverage/に出力）
COVERAGE=true bundle exec rspec
```

### リンティングとコード品質
```bash
# RuboCop実行
bundle exec rubocop

# 違反の自動修正
bundle exec rubocop -A
```

## アーキテクチャと主要コンポーネント

### 主要モデル
- **User**: `has_secure_password`による認証、多数のタスクを持つ
- **Task**: 名前/説明を持つメインエンティティ、ユーザーに属し、CSV インポート/エクスポートをサポート
- **Contact**: 連絡先管理用の追加モデル

### コントローラー
- **TasksController**: CSV エクスポート、Ransack による検索、Kaminari によるページネーション機能を持つメインCRUDインターフェース
- **SessionsController**: 認証処理
- **Admin名前空間**: 管理者ユーザー向けのユーザー管理
- **API::V1名前空間**: タスク用のJSON API

### 主要機能
- **認証**: Railsの`has_secure_password`を使用したセッションベース認証
- **検索**: タスクフィルタリング用のRansack gem
- **ページネーション**: タスク一覧用のKaminari gem
- **ファイルアップロード**: タスク画像用のActive Storage
- **CSV操作**: Taskモデルでのカスタムインポート/エクスポート機能
- **メール**: タスク作成通知付きのActionMailer
- **バックグラウンドジョブ**: SampleJobとのSidekiq統合
- **国際化**: 日本語ロケールサポート

### フロントエンド
- **テンプレートエンジン**: ERBの代わりにSlim
- **CSSフレームワーク**: カスタムSCSSを含むBootstrap 5
- **JavaScript**: TurboとStimulusコントローラー
- **ビルドツール**: アセットコンパイル用のBun、CSS処理用のPostCSS

### データベース
- **PostgreSQL**: プライマリデータベース
- **Redis**: バックグラウンドジョブ処理用
- **Active Storage**: ファイル添付

### テストスタック
- **RSpec**: メインのテストフレームワーク
- **Capybara**: Playwrightドライバーを使った統合テスト
- **FactoryBot**: テストデータ生成
- **SimpleCov**: コードカバレッジレポート
- **Guard**: 自動テスト実行

### 開発環境
プロジェクトはローカルとDockerベースの開発の両方をサポートしています：
- PostgreSQL、Redis、Mailcatcherサービスを含むDocker Compose
- 簡素化されたDockerコマンド管理用のDIP
- 自動テスト実行用のGuard
- http://lvh.me:50080 でのメールテスト用Mailcatcher

### デプロイメント
- Render.com（PaaS）にデプロイ
- Supabase（DaaS）でホストされるデータベース
- main/masterブランチへのマージでの自動デプロイ

## コードパターン

### モデルパターン
- スコープの使用（例：`Task.recent`）
- CSV操作とRansack設定用のクラスメソッド
- 日本語エラーメッセージを含むカスタムバリデーション
- dependent destroyを含むActiveRecordアソシエーション

### コントローラーパターン
- インスタンス変数設定用の`before_action`
- 全操作での現在ユーザースコープ
- 複数フォーマット（HTML/CSV）用のrespond_toブロック
- 明示的なpermitリストを持つストロングパラメータ

### ビューパターン
- アプリケーション全体でのSlimテンプレート
- 統一されたUI用のBootstrapコンポーネント
- ページネーション用にカスタマイズされたKaminariビュー
- Rails規約を使ったフォームヘルパー

### 設定
- デフォルトロケールとしての日本語
- config/environments/での環境固有設定
- データベースとRedis接続用のDocker環境変数
- モダンなJavaScript/CSSワークフロー用に設定されたアセットパイプライン