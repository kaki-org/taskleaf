require 'rails_helper'

describe 'タスク管理機能', type: :system do
  let(:user_a){ FactoryBot.create(:user, name: 'ユーザA', email: 'a@example.com')}
  let(:user_b){ FactoryBot.create(:user, name: 'ユーザB', email: 'b@example.com')}
  let!(:task_a){ FactoryBot.create(:task, name: '最初のタスク', user: user_a)}

  before do
    # ユーザAを作成
    # 作成者がユーザAであるタスクを作成
    @task = FactoryBot.create(:task, name: '最初のタスク', user: user_a)
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

  shared_examples_for 'ユーザAが作成したタスクが表示される' do
    it { expect(page).to have_content '最初のタスク' }
  end

  describe '一覧表示機能' do
    context 'ユーザAがログインしているとき' do
      let(:login_user) { user_a }

      it_behaves_like 'ユーザAが作成したタスクが表示される'
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
      it_behaves_like 'ユーザAが作成したタスクが表示される'
    end
  end

  describe '新規作成機能' do
    let(:login_user) { user_a }
    let(:task_name){'新規作成のテストを書く'} # デフォルトとして設定

    before do
      visit new_task_path
      fill_in '名称', with: task_name
      click_button '登録する'
    end

    context '新規作成画面で名称を入力したとき' do
      let(:task_name){'新規作成のテストを書く'} # デフォルトで設定されているので本来不要な行
      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く'
      end
    end
    context '新規作成画面で名称を入力しなかったとき' do
      let(:task_name) { '' }

      it 'エラーとなる' do
        within '#error_explanation' do
          expect(page).to have_content '名称を入力してください'
        end
      end
    end
  end
  # TODO
  # 更新機能
  describe '更新機能' do
    let(:login_user) { user_a }

    before do
      visit edit_task_path id: @task.id
    end
    context '更新画面で名称と詳しい説明を入力したとき' do
      it '正常に更新される' do
        fill_in '名称', with: '最初のタスク(更新後)'
        click_button '更新する'
        expect(page).to have_selector '.alert-success', text: '最初のタスク(更新後)'
      end
    end
  end
  # 削除機能
  # のテストを書く
end
