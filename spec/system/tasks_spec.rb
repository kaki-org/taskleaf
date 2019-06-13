require 'rails_helper'

describe 'タスク管理機能', type: :system do
  describe '一覧表示機能' do
    before do
      # ユーザAを作成
      user_a = FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com')
      # 作成者がユーザAであるタスクを作成
      FactoryBot.create(:task, name: '最初のタスク', user: user_a)
    end

    context 'ユーザAがログインしているとき' do
      before do
        # ユーザAでログインする
        # 1. ログイン画面にアクセス
        visit login_path
        # 2. メールアドレスを入力する
        fill_in 'メールアドレス', with: 'a@example.com'
        # 3. パスワードを入力する
        fill_in 'パスワード', with: 'password'
        # 4. ログインする
        click_button 'ログインする'
      end

      it 'ユーザAが作成したタスクが表示される' do
        # 作成済みのタスクの名前が画面上に表示されていることを確認
        expect(page).to have_content '最初のタスク'
      end
    end
  end
end
