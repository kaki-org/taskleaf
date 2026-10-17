# inertia-rails へのフロントエンドリプレース (#1838)

## 結論
ERB + Hotwire の画面を **inertia-rails + React (TypeScript) + vite_rails** に置き換える。ページ単位で段階的に移行し、ERB と Inertia が共存する期間を設ける。
小規模な CRUD アプリで session 認証が素直なこと、移行前後の挙動を Playwright の system spec で確認できることから、taskleaf を Inertia 移行の最初の対象に選んだ。

## 対象リポジトリの選定
| 候補 | 判断 | 理由 |
|---|---|---|
| **taskleaf** | **採用** | コントローラ 5・ERB ビュー 31 の単純な CRUD。admin が別系統でレイアウトを分ける練習になる。Playwright の system spec がある |
| rails8 | 次点 | 規模は最小で Hotwire もほぼ未使用。ただし OmniAuth GitHub のリダイレクトは Inertia の画面遷移に乗らない。OpenSearch 依存で手元の検証環境が重い。テストが RSpec と Minitest に分かれている |
| baukis2 | 後回し | 3 系統 (staff/admin/customer) をホストで分けている。ネストしたフォームと HTML 生成 presenter (約 14) の作り直しが重い。Inertia の型が固まってから着手する |

## 設計

### 構成
- gem: `inertia_rails`, `vite_rails`。npm: `@inertiajs/react`, `react`, `react-dom`, `typescript`, `@vitejs/plugin-react`
- ページは `app/frontend/pages/` に置く（`Tasks/Index.tsx`, `Admin/Users/Index.tsx` など）。admin pack のコントローラから `render inertia: 'Admin/Users/Index'` で参照する。packwerk は Ruby の定数しか検査しないため、JS 側は境界の対象外
- レイアウト: Inertia 用のルートテンプレート `app/views/layouts/inertia.html.erb` を新設し、移行したコントローラで `layout 'inertia'` を指定する。共通ヘッダは React の persistent layout（一般用と admin 用の 2 つ）にする
- CSS: 既存の Bootstrap 5 (SCSS) を Vite 経由で読み込み、見た目は変えない
- Vite は Node で動かす（`config/vite.json` の `viteBinPath`）。vite_ruby は `bun.lockb` があると `bun x --bun vite` で起動し、Bun ランタイムでは sass のコンパイルが失敗するため。パッケージのインストールは Bun のまま

### Rails 側の受け渡し
| 項目 | 方式 |
|---|---|
| ログインユーザー | `inertia_share` で全ページに共有する |
| flash | inertia-rails 3 の `flash_keys`（既定で `notice` / `alert`）で `page.flash` に渡す |
| バリデーションエラー | `redirect_to ..., inertia: { errors: }` で返し、フォームは `useForm` で表示する |
| CSRF | inertia-rails の XSRF-TOKEN cookie 連携を使う |
| 検索・ページネーション | ransack の検索条件と kaminari の結果を props（items + meta）で渡す。ERB の kaminari テンプレートは廃止する |
| 削除確認画面 (confirm_destroy) | 現行どおり別ページとして移植する。どこからも使われていない `confirm_new.html.erb` は移植せず削除する |
| CSV import | `useForm` で multipart 送信する |

### 移行ステップ（1 ステップ = 1 PR、Stacked PR）
1. **基盤**: vite_rails + inertia_rails を導入し、Inertia レイアウトと React のエントリを追加する。既存の ERB 画面は importmap のまま動かす。Ruby 4.0 / Rails 8.1 で両 gem が動くことをここで確認する
2. **ログイン**: `sessions#new` を Inertia 化する
3. **タスク**: `tasks` の一覧・検索・詳細・新規作成・編集・削除（確認画面を含む）・import を移す
4. **admin**: `admin/users` を移す
5. **撤去**: turbo-rails / stimulus-rails / importmap-rails / sprockets-rails / jsbundling・cssbundling (Bun)、残っている webpack・babel 依存、`*.turbo_stream.erb`、Stimulus コントローラを削除する

### テスト
- system spec（`logins_spec`, `tasks_hotwire_spec`, `admin/users*_spec`）は Playwright のまま、各ステップで操作手順とセレクタを更新する。Turbo 固有の検証は Inertia の画面遷移の検証に置き換える
- HTML を検証している request spec は、inertia-rails の RSpec ヘルパー（コンポーネント名・props の検証）に書き換える
- 各 PR で `rspec` の全件 PASS を確認してからマージする。CI に `tsc -b` の型チェックを追加する

## 検討した代替案
| 案 | 却下理由 |
|---|---|
| Vue / Svelte | inertia-rails の公式ドキュメントやジェネレータは React の例が最も充実している。今後 baukis2 に横展開するときにも資料を流用できる |
| Vite を使わず既存の Bun (jsbundling) で組む | inertia-rails のジェネレータと HMR が Vite 前提。現状の Bun ビルドはレイアウトから読まれておらず、作り直すのと手間が変わらない |
| 全画面を一括で置き換える | 30 画面規模でも、途中で system spec が全滅すると原因を切り分けられない。ページ単位なら PR ごとに PASS を確認できる |
| Hotwire のまま改善を続ける | 目的が Inertia + React の構成を検証することなので成立しない |

## Non-goals
- UI デザイン・画面遷移の変更（確認画面のモーダル化なども含む）
- SSR
- API v1 (`Api::V1::TasksController`) とメール (`task_mailer`) のビューの変更
- 認証方式の変更（`has_secure_password` + session を維持する）
- Bootstrap から別の CSS フレームワークへの移行
