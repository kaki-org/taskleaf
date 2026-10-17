# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'タスク画面', :js do
  include ActionView::RecordIdentifier

  let(:user) { create(:user, name: 'テストユーザー', email: 'test@example.com') }

  before do
    # ファクトリで自動作成されるタスクを削除
    user.tasks.destroy_all

    # ユーザーのタスクを追加作成（ページネーションテスト用）
    25.times do |i|
      create(:task, user: user, name: "タスク#{format('%02d', i + 1)}", description: "説明#{i + 1}")
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

  describe 'タスク一覧' do
    before { visit tasks_path }

    context 'ページネーションの場合' do
      it 'ページ2へ遷移してもページ全体がリロードされない' do
        expect(page).to have_content('タスク01')
        # フルリロードされると消える目印を置き、Inertia の画面遷移であることを確かめる
        page.execute_script('window.inertiaVisitMarker = true')

        within('.pagination') do
          click_link '2'
        end

        expect(page).to have_current_path(/page=2/)
        expect(page).to have_content('タスク21')
        expect(page.evaluate_script('window.inertiaVisitMarker')).to be true
      end
    end

    context '検索の場合' do
      it '検索条件で絞り込める' do
        fill_in '名称', with: 'タスク01'
        click_button '検索'

        expect(page).to have_current_path(/name_cont/)
        expect(page).to have_content('タスク01')
        expect(page).to have_no_content('タスク25')
        # 検索後も入力した条件が残る
        expect(page).to have_field('名称', with: 'タスク01')
      end
    end

    context '並び替えの場合' do
      it '名称の降順に並ぶ' do
        click_link '名称'

        expect(page).to have_link('名称 ▼')
        expect(page.first('#tasks-list tr td')).to have_text('タスク25')
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
      expect(page).to have_no_css("##{dom_id(task)}")
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
      expect(page).to have_no_content("タスク「#{task_name}」を削除しました")
    end
  end

  describe 'タスク新規作成' do
    it '新規作成後にタスク詳細に遷移しフラッシュが表示される' do
      visit tasks_path
      click_link '新規登録'

      expect(page).to have_content('タスクの新規登録')

      fill_in '名称', with: '新しいタスク'
      fill_in '詳しい説明', with: '新しいタスクの説明'
      click_button '登録する'

      # フラッシュメッセージが表示される
      expect(page).to have_content('タスク「新しいタスク」を登録しました')
    end

    it '入力に誤りがあるとエラーを表示し入力内容を残す' do
      visit new_task_path

      fill_in '詳しい説明', with: '名称のないタスク'
      click_button '登録する'

      expect(page).to have_content('名称を入力してください')
      expect(page).to have_field('詳しい説明', with: '名称のないタスク')
    end

    it '画像を添付して登録できる' do
      visit new_task_path

      fill_in '名称', with: '画像つきタスク'
      attach_file '画像', Rails.root.join('spec/factories/redkaki.png')
      click_button '登録する'

      expect(page).to have_content('タスク「画像つきタスク」を登録しました')
      expect(page).to have_css("img[alt='画像つきタスク']")
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

  describe 'CSV インポート' do
    it 'CSV を取り込むとフラッシュが表示される' do
      visit tasks_path

      attach_file 'file', Rails.root.join('spec/fixtures/files/tasks.csv')
      click_button 'インポート'

      expect(page).to have_content(I18n.t('task_created'))
    end
  end
end
