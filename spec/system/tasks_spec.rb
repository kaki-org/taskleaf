# frozen_string_literal: true

require 'rails_helper'
require 'support/download_helper'

describe 'タスク管理機能', type: :system do
  let(:user_a) { create(:user, name: 'ユーザA', email: 'a@example.com') }
  let(:user_b) { create(:user, name: 'ユーザB', email: 'b@example.com') }
  let!(:task_a) { create(:task, name: '最初のタスク', user: user_a) }

  before do
    Selenium::WebDriver.logger
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
    visit current_path
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

    context '特別な日の判定' do
      let(:login_user) { user_b }
      it '誕生日には画面上にバースデーメッセージが出力される' do
        travel_to(Time.parse('2020-03-13'))
        visit tasks_path
        expect(page).to have_content 'お誕生日おめでとうございます'
      end
      it '通常は画面上にバースデーメッセージが出力されない' do
        travel_to(Time.parse('2020-03-08'))
        visit tasks_path
        expect(page).not_to have_content 'お誕生日おめでとうございます'
        freeze_time
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザAがログインしているとき' do
      let(:login_user) { user_a }
      before do
        Selenium::WebDriver.logger
        visit task_path(task_a)
      end
      it_behaves_like 'ユーザAが作成したタスクが表示される'
    end
  end

  describe '新規作成機能' do
    let(:login_user) { user_a }
    let(:task_name) { '新規作成のテストを書く' } # デフォルトとして設定

    before do
      Selenium::WebDriver.logger
      visit new_task_path
      fill_in '名称', with: task_name
      attach_file '画像', "#{Rails.root}/spec/factories/redkaki.png"
    end

    context '新規作成画面で名称を入力したとき' do
      let(:task_name) { '新規作成のテストを書く' } # デフォルトで設定されているので本来不要な行
      # let(:avatar) { attributes_for(:task_with_avatar)}

      # it '確認画面が表示される' do
      #   expect(page).to have_content task_name
      #   # expect(page).to have_content name: '登録内容の確認'
      # end
      before do
        click_button '登録'
      end
      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く'
        expect(Task.last.image.blob.filename).to eq 'redkaki.png'
      end
      it 'メールが送信される' do
        # TODO: ここはそもそもsenderが取れない。。当たり前だが
        # expect(open_last_email).to be_delivered_from sender.email
        expect(last_email).to be_delivered_to 'user@example.com'
        expect(last_email).to be_delivered_from 'taskleaf@example.com'
        expect(last_email).to have_subject 'タスク作成完了メール'
        expect(last_email).to have_body_text '以下のタスクを作成しました'
      end
    end
    context '新規作成画面で名称を入力しなかったとき' do
      let(:task_name) { '' }

      before do
        click_button '登録'
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
      Selenium::WebDriver.logger
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

  # 検索機能(ransack)
  describe '検索機能' do
    let(:login_user) { user_a }

    before do
      Selenium::WebDriver.logger
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

  # 削除機能
  describe '削除機能' do
    let(:login_user) { user_a }

    before do
      Selenium::WebDriver.logger
      visit task_path id: @task.id
    end
    context '削除ボタンを押す', js: true do
      before '確認ダイアログが表示される' do
        sleep 1
        click_link '削除'
      end
      it 'タスクが削除される' do
        expect(page.driver.browser.switch_to.alert.text).to eq 'タスク「次のタスク」を削除します。よろしいですか？'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '「次のタスク」を削除しました'
      end
    end
  end
end
