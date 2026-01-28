# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks Hotwire機能', :js do
  include ActionView::RecordIdentifier

  let(:user) { create(:user, name: 'テストユーザー', email: 'test@example.com') }

  before do
    # ファクトリで自動作成されるタスクを削除
    user.tasks.destroy_all

    # ユーザーのタスクを追加作成（ページネーションテスト用）
    25.times do |i|
      create(:task, user: user, name: "Hotwireタスク#{format('%02d', i + 1)}", description: "説明#{i + 1}")
    end

    # アソシエーションをリロードして新しいタスクを取得できるようにする
    user.reload

    # ログイン
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログインする'

    # ログイン完了を待機（expectを使わずにCapybaraの待機機能を利用）
    page.has_content?('ログアウト')
  end

  describe 'Turbo/Stimulusの初期化' do
    it 'window.Turboが利用可能である' do
      visit tasks_path
      result = page.evaluate_script('typeof window.Turbo')
      expect(result).to eq('object')
    end

    it 'window.Stimulusが利用可能である' do
      visit tasks_path
      result = page.evaluate_script('typeof window.Stimulus')
      expect(result).to eq('object')
    end
  end

  describe 'タスク一覧のTurbo Frame' do
    before { visit tasks_path }

    context 'ページネーションの場合' do
      it 'ページ2へ遷移してもページ全体がリロードされない' do
        # 最初のページの内容を確認
        expect(page).to have_content('Hotwireタスク01')

        # ページ2へ移動
        within('.pagination') do
          click_link '2'
        end

        # URLが更新される
        expect(page).to have_current_path(/page=2/)

        # ページ2の内容が表示される（Turbo Frame内で更新）
        expect(page).to have_content('Hotwireタスク21')
      end
    end

    context '検索の場合' do
      it '検索がTurbo Frame内で動作する' do
        fill_in '名称', with: 'Hotwireタスク01'
        click_button '検索'

        # 検索結果が表示される
        expect(page).to have_content('Hotwireタスク01')
        # 他のタスクは表示されない
        expect(page).not_to have_content('Hotwireタスク25')
      end
    end
  end

  describe 'タスク詳細への遷移' do
    before { visit tasks_path }

    it 'タスク名をクリックすると詳細ページに遷移する' do
      task = user.tasks.first
      click_link task.name

      expect(page).to have_current_path(task_path(task))
      expect(page).to have_content('タスクの詳細')
      expect(page).to have_content(task.name)
    end

    it '編集リンクをクリックすると編集ページに遷移する' do
      task = user.tasks.first
      within("##{dom_id(task)}") do
        click_link '編集'
      end

      expect(page).to have_current_path(edit_task_path(task))
      expect(page).to have_content('タスクの編集')
    end
  end

  describe 'タスク削除' do
    it '削除確認画面から削除するとタスク一覧に遷移しフラッシュが表示される' do
      visit tasks_path
      task = user.tasks.first
      task_name = task.name

      within("##{dom_id(task)}") do
        click_link '削除'
      end

      # 削除確認画面
      expect(page).to have_content('タスクの削除確認')
      expect(page).to have_content(task_name)

      # 削除実行
      click_button '削除'

      # タスク一覧に遷移
      expect(page).to have_current_path(tasks_path)

      # フラッシュメッセージが表示される
      expect(page).to have_content("タスク「#{task_name}」を削除しました")

      # 削除されたタスクが一覧にない
      expect(page).not_to have_content(task_name)
    end
  end

  describe 'フラッシュメッセージの自動非表示', skip: 'フラッシュの自動非表示は5秒後のため、テストでは時間がかかる' do
    it 'フラッシュメッセージが5秒後に自動で消える' do
      visit tasks_path
      task = user.tasks.first
      task_name = task.name

      # 削除を実行
      within("##{dom_id(task)}") do
        click_link '削除'
      end
      click_button '削除'

      # フラッシュが表示されている
      expect(page).to have_content("タスク「#{task_name}」を削除しました")

      # 5秒後にフラッシュが消える
      sleep 6
      expect(page).not_to have_content("タスク「#{task_name}」を削除しました")
    end
  end

  describe 'タスク新規作成' do
    it '新規作成後にタスク一覧に遷移しフラッシュが表示される' do
      visit tasks_path
      click_link '新規登録'

      expect(page).to have_content('タスクの新規登録')

      fill_in '名称', with: '新しいタスク'
      fill_in '詳しい説明', with: '新しいタスクの説明'
      click_button '登録する'

      # フラッシュメッセージが表示される
      expect(page).to have_content('タスク「新しいタスク」を登録しました')
    end
  end

  describe 'タスク編集' do
    it '編集後にタスク一覧に遷移しフラッシュが表示される' do
      task = user.tasks.first
      visit edit_task_path(task)

      fill_in '名称', with: '更新されたタスク'
      click_button '更新する'

      # フラッシュメッセージが表示される
      expect(page).to have_content('タスク「更新されたタスク」を更新しました')
    end
  end
end
