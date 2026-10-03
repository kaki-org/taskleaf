# API v1 のルーティング限定と未認証時の JSON 401 応答 (#1695)

## 結論
`resources :tasks, only: %i[show update destroy]` で公開ルートを実装済みアクションに限定する。
`Api::V1::TasksController` で `login_required` をオーバーライドし、未ログイン時は `{ error: 'Unauthorized' }` を 401 で返す。
HTML 側の挙動（ログイン画面へのリダイレクト）は変えない。

## 設計
- 401 の本文は既存の `record_not_found`（`{ error: 'Task not found' }`）と同じ形式にそろえる。`head :unauthorized` だと本文が空になり、API クライアントがエラー種別を他の応答と同じ方法で読めないため
- オーバーライドは API コントローラ内に置く。API コントローラは現在 1 つだけなので、基底クラス（`Api::BaseController`）は作らない

## 検討した代替案
| 案 | 却下理由 |
|---|---|
| `ApplicationController#login_required` で `request.format.json?` により分岐 | API クライアントが Accept ヘッダを付けないと HTML 側に流れる。既存 spec も `application/vnd.tasks.v1` を送っており JSON 判定にならない |
| `Api::BaseController` を新設して継承させる | API コントローラが 1 つの現状では抽象化が早い |
| `head :unauthorized` | 本文が空になり、他のエラー応答と形式がそろわない |

## Non-goals
- トークン認証の導入（#1561）
- API の CSRF 対策の見直し
- index / create の実装
