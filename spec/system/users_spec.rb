# frozen_string_literal: true

require 'rails_helper'
require 'support/download_helper'

describe 'タスク管理機能', type: :system do
  let(:user_a) { create(:user, name: 'ユーザA', email: 'a@example.com') }
  let(:user_b) { create(:user, name: 'ユーザB', email: 'b@example.com') }
  let!(:task_a) { create(:task, name: '最初のタスク', user: user_a) }

  before do
    # ユーザAを作成
    # 作成者がユーザAであるタスクを作成
    @task = create(:task, name: '次のタスク', description: '詳細な説明', user: user_a)
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
    let(:task_name) { '新規作成のテストを書く' } # デフォルトとして設定

    before do
      visit new_task_path
      fill_in '名称', with: task_name
    end

    context '新規作成画面で名称を入力したとき' do
      let(:task_name) { '新規作成のテストを書く' } # デフォルトで設定されているので本来不要な行

      before do
        click_button '登録する'
      end
      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く'
      end
    end
    context '新規作成画面で名称を入力しなかったとき' do
      let(:task_name) { '' }

      before do
        click_button '登録する'
      end
      it 'エラーとなる' do
        within '#error_explanation' do
          expect(page).to have_content '名称を入力してください'
        end
      end
    end
  end
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
    context '更新画面で名称を入力しなかったとき' do
      it 'エラーとなる' do
        fill_in '名称', with: ''
        click_button '更新する'
        within '#error_explanation' do
          expect(page).to have_content '名称を入力してください'
        end
      end
    end
  end

  # 検索機能(ransack)
  describe '検索機能' do
    let(:login_user) { user_a }

    before do
      visit tasks_path q: { name_cont: '最初' }
    end
    context '検索結果を確認したとき' do
      it_behaves_like 'ユーザAが作成したタスクが表示される'
      # it '登録したタスクが確認できる' do
      #   expect(page).to have_content '最初のタスク'
      # end
    end
    before do
      visit tasks_path q: { description_cont: '詳細な説明' }
    end
    context '不正な検索結果を確認したとき' do
      it '登録したタスク以外も出力されている' do
        expect(page).to have_content '最初のタスク'
      end
    end
  end

  # TODO
  # 削除機能
  describe '削除機能', js: true do
    let(:login_user) { user_a }

    before do
      visit task_path(@task)
    end
    context '削除ボタンを押す' do
      it '確認ダイアログが表示される' do
        visit task_path(@task) # うまく遷移できてないことが多いのでリロードの意味で再度visitを呼び出す
        sleep 1
        click_link '削除'
        expect(page.driver.browser.switch_to.alert.text).to eq 'タスク「次のタスク」を削除します。よろしいですか？'
        # expect(page.driver.browser.accept_js_confirms.text).to eq 'タスク「次のタスク」を削除します。よろしいですか？'
      end
    end
  end
  # のテストを書く
end
