# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Users Hotwire機能', :js do
  include ActionView::RecordIdentifier

  let(:admin_user) { create(:admin, name: '管理者ユーザ', email: 'admin@example.com') }

  before do
    # 追加ユーザーを作成
    5.times do |i|
      create(:user, name: "テストユーザ#{format('%02d', i + 1)}", email: "user#{i + 1}@example.com")
    end

    # 管理者でログイン
    visit login_path
    fill_in 'メールアドレス', with: admin_user.email
    fill_in 'パスワード', with: admin_user.password
    click_button 'ログインする'

    # ログイン完了を待機
    page.has_content?('ログアウト')
  end

  describe 'ユーザー一覧のTurbo Frame' do
    before { visit admin_users_path }

    it 'turbo-frameタグが存在する' do
      expect(page).to have_css('turbo-frame#users')
    end

    it 'ユーザー一覧が表示される' do
      expect(page).to have_content('テストユーザ01')
      expect(page).to have_content('テストユーザ02')
    end
  end

  describe 'ユーザー詳細への遷移' do
    before { visit admin_users_path }

    it 'ユーザー名をクリックすると詳細ページに遷移する' do
      user = User.find_by(name: 'テストユーザ01')
      click_link 'テストユーザ01'

      expect(page).to have_current_path(admin_user_path(user))
    end

    it '編集リンクをクリックすると編集ページに遷移する' do
      user = User.find_by(name: 'テストユーザ01')
      within("##{dom_id(user)}") do
        click_link '編集'
      end

      expect(page).to have_current_path(edit_admin_user_path(user))
    end
  end

  describe 'ユーザー削除' do
    let(:target_user) { create(:user, name: '削除対象ユーザ', email: 'target@example.com') }

    before do
      target_user
      visit admin_users_path
    end

    it '削除確認画面から削除するとユーザー一覧に遷移しフラッシュが表示される' do
      within("##{dom_id(target_user)}") do
        click_link '削除'
      end

      # 削除確認画面
      expect(page).to have_content('ユーザ削除確認')
      expect(page).to have_content(target_user.name)

      # 削除実行
      click_button '削除'

      # ユーザー一覧に遷移
      expect(page).to have_current_path(admin_users_path)

      # フラッシュメッセージが表示される
      expect(page).to have_content("ユーザー「#{target_user.name}」を削除しました")

      # 削除されたユーザーが一覧にない
      expect(page).not_to have_content(target_user.email)
    end
  end

  describe 'ユーザー新規作成' do
    it '新規作成後にユーザー詳細に遷移しフラッシュが表示される' do
      visit admin_users_path
      click_link '新規登録'

      expect(page).to have_current_path(new_admin_user_path)

      fill_in '名前', with: '新しいユーザ'
      fill_in 'メールアドレス', with: 'newuser@example.com'
      fill_in 'パスワード', with: 'password123'
      fill_in 'パスワード(確認)', with: 'password123'
      click_button '登録する'

      # フラッシュメッセージが表示される
      expect(page).to have_content('ユーザー「新しいユーザ」を登録しました')
    end
  end

  describe 'ユーザー編集' do
    it '編集後にユーザー詳細に遷移しフラッシュが表示される' do
      user = User.find_by(name: 'テストユーザ01')
      visit edit_admin_user_path(user)

      fill_in '名前', with: '更新されたユーザ'
      fill_in 'パスワード', with: 'newpassword123'
      fill_in 'パスワード(確認)', with: 'newpassword123'
      click_button '登録する'

      # フラッシュメッセージが表示される
      expect(page).to have_content('ユーザー「更新されたユーザ」を更新しました')
    end
  end
end
