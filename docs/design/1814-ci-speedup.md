# CI（Build ワークフロー）の高速化 (#1814)

## 結論
`Build` を develop への push でも実行し、PR 間で共有できる default branch のキャッシュを作る。これで最大のボトルネックである gem のフルインストール（約 60s）を解消する。
あわせて postgres の health check の短縮、setup-ruby と重複するステップの削除、Playwright ブラウザのキャッシュを行う。新規 PR の初回 run を 156s から 85〜90s 程度に縮める。
変更は `.github/workflows/ruby.yml` のみ。施策ごとに 1 PR とする。

## 設計
| # | 変更 | 根拠 |
|---|---|---|
| 1 | `on.push.branches` に `develop` を追加する | Actions のキャッシュはブランチスコープで、PR からは自分の PR と base branch のキャッシュしか読めない。現状のキャッシュはすべて `refs/pull/*` スコープで PR 間で共有されず、新規 PR では毎回フルインストールになる。setup-bun のキャッシュにも同じ効果がある |
| 4 | postgres の `options` を `--health-interval 2s --health-timeout 2s --health-retries 15` にする | 起動を待つ上限は 30s 程度のまま、確認間隔 10s 分の無駄待ちを削る |
| 6 | `gem install bundler`、`vendor/bundle` 指定の手動 `bundle install`、`echo` だけの `tmp cache clear` を削除する | 前の 2 つは `bundler-cache: true` が Gemfile.lock の `BUNDLED WITH`（4.0.3）で行う処理と重複する。`gem install bundler` は最新版を入れるため、バージョンがずれる原因にもなる |
| 3 | `~/.cache/ms-playwright` を `actions/cache` でキャッシュし、ヒットしたらインストールを省く | 毎回ダウンロードしている約 10s を削る。キャッシュのキーは `node_modules/playwright-core/package.json` の version とする（`bun.lockb` はバイナリで、無関係な依存の更新でもキャッシュが無効になるため） |

効果を確認する方法:
- #4・#6・#3: 各 PR の run の時間をステップ別に比較する。
- #1: develop へのマージ後に作る新規 PR で、`Setup Ruby` に "Cache restored" が出ることと、所要時間を確認する（#1 の PR 自身の run では効果は確認できない）。

## 検討した代替案
| 案 | 却下理由 |
|---|---|
| キャッシュを温める専用ワークフローを develop で動かす | ruby/bun のキャッシュキーを `Build` と完全に揃える必要があり、二重管理になる。`Build` 自体を develop で走らせれば、カバレッジの基準値も Codecov に送れる |
| テスト並列化（parallel_tests / matrix 分割） | RSpec の実処理は 25s しかなく、分割すると setup が分割数ぶん重複するため、改善は 10〜15s にとどまる |
| Playwright のキャッシュキーに `hashFiles('bun.lockb')` を使う | Playwright 以外の JS 依存を更新するたびにブラウザを再ダウンロードしてしまう |
| `--no-shell` で Headless Shell の取得をやめる | system spec が Headless Shell で起動している。`driven_by :playwright` を呼ぶと Rails 8.1 が `:playwright` ドライバーを channel なしで登録し直し、`rails_helper.rb` で登録した設定（`PLAYWRIGHT_CHROMIUM_CHANNEL`）を上書きするため（#1818 の CI で `chrome-headless-shell` が見つからずに失敗した） |

## Non-goals
- dependabot の groups 化と Renovate との二重管理の解消（Issue #2。CI 設定ではなく依存更新の運用の話なので別途扱う）
- `paths-ignore` の追加（Issue #5。`rspec_job` が必須チェックなので、skip されると PR をマージできなくなる。回避策の設計が別に必要）
- `PLAYWRIGHT_CHROMIUM_CHANNEL` が効いていない問題の修正（テストの実行環境が変わるので別 Issue で扱う）
- lint ジョブの分離（Issue #7）と `ruby/setup-ruby@master` の固定（Issue #8）
