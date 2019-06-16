require 'rails_helper'

describe 'タスク管理機能', type: :system do
  let(:user_a){ FactoryBot.create(:user, name: 'ユーザA', email: 'a@example.com')}
  let(:user_b){ FactoryBot.create(:user, name: 'ユーザB', email: 'b@example.com')}
  let!(:task_a){ FactoryBot.create(:task, name: '最初のタスク', user: user_a)}

  before do
    # ユーザAを作成
    # 作成者がユーザAであるタスクを作成
    FactoryBot.create(:task, name: '最初のタスク', user: user_a)
    # ユーザAでログインする
    # 1. ログイン画面にアクセス
    visit login_path
    # 2. メールアドレスを入力する
    fill_in 'メールアドレス', with: login_user.email
    # 3. パスワードを入力する
    fill_in 'パスワード', with: login_user.password
    # 4. ログインする
    click_button 'ログインする'
  end

  describe '一覧表示機能' do
    context 'ユーザAがログインしているとき' do
      let(:login_user) { user_a }
      it 'ユーザAが作成したタスクが表示される' do
        # 作成済みのタスクの名前が画面上に表示されていることを確認
        expect(page).to have_content '最初のタスク'
      end
    end

    context 'ユーザBがログインしているとき' do
      let(:login_user) { user_b }
      it 'ユーザAが作成したタスクが表示されない' do
        # ユーザAが作成したタスクの名前が画面上に表示されていない事を確認
        # expect(page).to have_no_content '最初のタスク' # これでもいい
        expect(page).not_to have_content '最初のタスク'
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザAがログインしているとき' do
      let(:login_user) { user_a }
      before do
        visit task_path(task_a)
      end
      it 'ユーザAが作成したタスクが表示される' do
        expect(page).to have_content '最初のタスク'
      end
    end
  end
end
