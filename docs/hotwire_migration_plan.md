# Hotwire移行計画

## 現状分析

| 項目 | 状態 |
|------|------|
| turbo-rails gem | ✅ インストール済み (`>= 2.0.12`) |
| stimulus-rails gem | ✅ インストール済み |
| Turbo Drive | ✅ 有効化済み |
| Turbo Frames | ✅ タスク一覧で使用中 |
| Turbo Streams | ✅ タスク削除で使用中 |
| Stimulusコントローラー | ✅ flash, form, hello |
| 古い.js.erb | ✅ 削除済み |

---

## Phase 1: 基盤整備（必須）

### 1.1 Stimulusのセットアップ
- `app/frontend/controllers/` ディレクトリ作成
- `index.js`でコントローラーの自動読み込み設定
- `application.js`でStimulus初期化

### 1.2 Turbo Driveの有効化
- `Turbo.session.drive = false` を削除
- 動作確認（ページ遷移がSPA風に動作するか）
- 問題があるページは `data-turbo="false"` で個別対応

### 1.3 レガシーコードの整理
- `data-turbolinks-track` → `data-turbo-track` に置換
- 不要なTurbolinks時代の設定を削除

---

## Phase 2: Tasksページの改善

### 2.1 タスク一覧（index）のTurbo Frame化
- タスクテーブルを`turbo_frame_tag`で囲む
- ページネーションをTurbo Frames対応
- 検索フォームをTurbo Frames対応（インライン検索）

### 2.2 タスクCRUD操作のTurbo Streams化
- 新規作成: タスク追加時にページリロードなしで一覧に追加
- 編集: モーダルまたはインライン編集
- 削除: `destroy.js.erb` → Turbo Stream レスポンスに置換

### 2.3 Stimulusコントローラー追加
- `flash_controller.js`: フラッシュメッセージの自動非表示
- `form_controller.js`: フォームバリデーションUI
- `modal_controller.js`: Bootstrap モーダル連携

---

## Phase 3: Admin/Usersページの改善

### 3.1 ユーザー一覧のTurbo Frame化
- Phase 2.1と同様のアプローチ

### 3.2 ユーザー管理CRUDのTurbo Streams化
- Phase 2.2と同様のアプローチ

---

## Phase 4: 全体的なUX改善

### 4.1 共通Stimulusコントローラー
- `dropdown_controller.js`: ドロップダウンメニュー
- `confirm_controller.js`: 削除確認ダイアログ
- `loading_controller.js`: ローディングインジケーター

### 4.2 リアルタイム更新（オプション）
- Action Cable + Turbo Streamsでリアルタイム通知
- 複数ユーザー間のタスク同期

---

## 推奨する作業順序

```
Phase 1.1 → 1.2 → 1.3（基盤）
    ↓
Phase 2.1 → 2.2 → 2.3（Tasks）
    ↓
Phase 3.1 → 3.2（Admin）
    ↓
Phase 4（UX改善）
```

---

## 注意事項

1. **段階的移行**: 全ページ同時ではなく、1ページずつ移行してテスト
2. **フォールバック**: 問題発生時は `data-turbo="false"` で一時的に無効化可能
3. **テスト**: Capybaraテストは Turbo対応の調整が必要になる可能性あり
4. **Bootstrap連携**: Bootstrapのモーダル/ドロップダウンはStimulus経由で制御推奨

---

## 進捗トラッキング

- [x] Phase 1.1: Stimulusセットアップ
- [x] Phase 1.2: Turbo Drive有効化
- [x] Phase 1.3: レガシーコード整理
- [x] Phase 2.1: タスク一覧Turbo Frame化
- [x] Phase 2.2: タスクCRUD Turbo Streams化
- [x] Phase 2.3: Stimulusコントローラー追加
- [ ] Phase 3.1: ユーザー一覧Turbo Frame化
- [ ] Phase 3.2: ユーザー管理Turbo Streams化
- [ ] Phase 4.1: 共通Stimulusコントローラー
- [ ] Phase 4.2: リアルタイム更新
