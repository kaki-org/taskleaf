# frozen_string_literal: true

require 'rails_helper'

describe 'Admin Users管理機能', :js do
  let(:admin_user) { create(:admin, name: '管理者ユーザ', email: 'admin@example.com') }
  let(:target_user) { create(:user, name: '削除対象ユーザ', email: 'target@example.com') }

  before do
    # 管理者でログイン
    visit login_path
    fill_in 'メールアドレス', with: admin_user.email
    fill_in 'パスワード', with: admin_user.password
    click_button 'ログインする'

    # ログイン完了を待機（Turbo対応）
    page.has_content?('ログアウト')
  end

  describe 'ユーザー削除機能' do
    before do
      target_user # 削除対象ユーザを作成
      visit admin_users_path
    end

    context 'ユーザー一覧から削除確認画面に遷移したとき' do
      before do
        within('tr', text: target_user.name) do
          click_link '削除'
        end
      end

      it '削除確認画面が表示される' do
        expect(page).to have_content('ユーザ削除確認')
        expect(page).to have_content('削除します。よろしいですか？')
        expect(page).to have_content(target_user.name)
        expect(page).to have_content(target_user.email)
      end

      it '削除ボタンをクリックするとユーザーが削除される' do
        expect do
          click_link_or_button '削除'
          expect(page).to have_content('ユーザー一覧')
        end.to change(User, :count).by(-1)
      end

      it '削除後に一覧画面にリダイレクトされる' do
        click_link_or_button '削除'
        expect(page).to have_current_path(admin_users_path)
      end

      it '削除後に削除したユーザーが一覧テーブルに表示されない' do
        click_link_or_button '削除'
        within('table') do
          expect(page).not_to have_content(target_user.name)
        end
      end
    end
  end
end
