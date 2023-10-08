# frozen_string_literal: true

require 'rails_helper'

describe Task do
  context 'ログインしている場合' do
    include_context 'userでログイン済みの時'
    let(:user) { create(:user, admin: true, email: 'test@example.com', password: 'password') }

    context '通常のタスク一覧の場合' do
      before do
        create(:user, email: 'test2@example.com', password: 'password')
        create(:task, name: '最初のタスク', user:)
        create(:task, name: '次のタスク', user:)
        create(:task, name: '最後のタスク', user:)
        get '/tasks'
      end

      it 'okがかえってくること' do
        expect(response).to have_http_status :ok
      end

      it 'タスク一覧が表示されること' do
        expect(response.body).to match(/最初のタスク|次のタスク|最後のタスク/)
      end

      it '通常は画面上にバースデーメッセージが出力されない' do
        expect(response.body).not_to include 'お誕生日おめでとうございます'
      end
    end

    context '特別な日の判定をする場合' do
      before do
        travel_to(Time.zone.parse('2020-03-13')) do
          get '/tasks'
        end
      end

      it '誕生日には画面上にバースデーメッセージが出力される' do
        expect(response.body).to include 'お誕生日おめでとうございます'
      end
    end
  end

  context 'ログインしていない場合' do
    before { get '/tasks' }

    it 'foundが返ってくること' do
      expect(response).to have_http_status :found
    end

    it 'ログイン画面に遷移する事' do
      expect(response).to require_login
    end
  end

  context '他人でログインしている場合' do
    include_context 'other_userでログイン済みの時'
    let(:other_user) { create(:user, admin: true, email: 'other@example.com', password: 'password') }
    let(:user) { create(:user, admin: true, email: 'test@example.com', password: 'password') }

    before do
      create(:task, name: '他人のタスク', user: other_user)
      create(:task, name: '最初のタスク', user:)
      create(:task, name: '次のタスク', user:)
      create(:task, name: '最後のタスク', user:)

      get '/tasks'
    end

    it 'okレスポンスがかえってくること' do
      expect(response).to have_http_status :ok
    end

    it '他人のタスクの一覧のみ取得できる事' do
      expect(response.body).to include '他人のタスク'
    end

    it '自分のタスクの一覧は取得できない事' do
      expect(response.body).not_to match(/(最初のタスク|次のタスク|最後のタスク)/)
    end
  end

  describe '新規作成画面' do
    include_context 'userでログイン済みの時'
    let(:user) { create(:user, admin: true, email: 'admin@example.com', password: 'password') }

    before { get '/tasks/new' }

    it 'okレスポンスがかえってくること' do
      expect(response).to have_http_status :ok
    end

    it '新規作成画面が表示される事' do
      expect(response.body).to include 'タスクの新規登録'
    end
  end

  describe '新規作成機能' do
    include_context 'userでログイン済みの時'
    let(:user) { create(:user, admin: true, email: 'admin@example.com', password: 'password') }
    let(:task_params) { attributes_for(:task) }

    context '正しいパラメータを送信するとき' do
      before do
        post tasks_path, params: { task: task_params }
      end

      it 'foundレスポンスがかえってきていること' do
        expect(response).to have_http_status :found
      end

      it 'タスクを作成できる事' do
        expect(described_class.last.name).to eq task_params[:name]
      end

      it 'メールが送信される事' do
        sender = ActionMailer::Base.deliveries.last.from
        expect(last_email).to be_delivered_from sender
      end

      it 'メールの宛先が正しいこと' do
        expect(last_email).to be_delivered_to 'user@example.com'
      end

      it 'メールの送信元が正しいこと' do
        expect(last_email).to be_delivered_from 'taskleaf@example.com'
      end

      it 'メールの件名が正しいこと' do
        expect(last_email).to have_subject 'タスク作成完了メール'
      end

      it 'メールの本文が正しいこと' do
        expect(last_email).to have_body_text '以下のタスクを作成しました'
      end
    end

    context '不正なパラメータを送信するとき' do
      let(:task_params) { attributes_for(:task, name: '') }

      before do
        post tasks_path, params: { task: task_params }
      end

      it 'タスクの作成に失敗する事' do
        expect(response).to have_http_status :ok
      end

      it 'エラーメッセージが表示される事' do
        expect(response.body).to include '名称を入力してください'
      end
    end
  end

  describe '詳細表示機能' do
    include_context 'userでログイン済みの時'
    let(:user) { create(:user, admin: true, email: 'admin@example.com', password: 'password') }
    let(:task) { create(:task, user:) }

    before { get task_path(task.id) }

    it 'okレスポンスがかえってくること' do
      expect(response).to have_http_status :ok
    end

    it 'タスクの詳細が表示される事' do
      expect(response.body).to include task.name
    end
  end

  describe '編集機能' do
    include_context 'userでログイン済みの時'
    let(:user) { create(:user, admin: true, email: 'admin@example.com', password: 'password') }
    let(:task) { create(:task, user:) }
    let(:new_task_name) { '新しいタスク名' }

    before do
      patch task_path(task.id), params: { task: { name: new_task_name } }
    end

    it 'foundのレスポンスがかえってくること' do
      expect(response).to have_http_status :found
    end

    it 'タスクの編集ができる事' do
      expect(described_class.last.name).to eq new_task_name
    end
  end

  describe '編集機能で失敗' do
    include_context 'userでログイン済みの時'
    let(:user) { create(:user, admin: true, email: 'admin@example.com', password: 'password') }
    let(:task) { create(:task, user:) }
    let(:new_task_name) { '' }

    before do
      patch task_path(task.id), params: { task: { name: new_task_name } }
    end

    it 'okでレスポンスがかえってくること' do
      expect(response).to have_http_status :ok
    end

    it 'タスクの編集ができる事' do
      expect(response.body).to include '名称を入力してください'
    end
  end

  describe '検索機能' do
    include_context 'userでログイン済みの時'
    let(:user) { create(:user, admin: true, email: 'admin@example.com', password: 'password') }
    let(:other_user) { create(:user, admin: true) }

    context 'タイトルで検索する場合' do
      before do
        create(:task, name: '最初のタスク', user:)
        create(:task, name: '次のタスク', user:)
        create(:task, name: '最後のタスク', user:)
        create(:task, name: 'ユーザ2の最初のタスク', user: other_user)
        get '/tasks', params: { q: { name_cont: '最初のタスク' } }
      end

      it '検索キーワードによる絞り込みで最初のタスクが表示されること' do
        expect(response.body).to include '最初のタスク'
      end

      it '検索キーワードによる絞り込みで次のタスクが表示されないこと' do
        expect(response.body).not_to include '次のタスク'
      end

      it '検索キーワードによる絞り込みで最後のタスクが表示されないこと' do
        expect(response.body).not_to include '最後のタスク'
      end

      it 'ユーザ2のタスクは表示されない事' do
        expect(response.body).not_to include 'ユーザ2の最初のタスク'
      end
    end
  end

  describe '削除確認画面' do
    include_context 'userでログイン済みの時'
    let(:user) { create(:user, admin: true, email: 'admin@example.com', password: 'password') }
    let!(:task) { create(:task, user:) }

    before do
      get "/tasks/#{task.id}/confirm_destroy"
    end

    it 'タスク削除のレスポンスが200であること' do
      expect(response).to have_http_status :ok
    end

    it 'タスクの削除確認画面が表示される事' do
      expect(response.body).to include '削除します。よろしいですか？'
    end

    it 'タスクの詳細が表示される事' do
      expect(response.body).to include task.name
    end
  end

  describe '削除機能' do
    include_context 'userでログイン済みの時'
    let(:user) { create(:user, admin: true, email: 'admin@example.com', password: 'password') }
    let!(:task) { create(:task, user:) }

    before do
      delete "/tasks/#{task.id}"
    end

    it 'レスポンスがfoundであること' do
      expect(response).to have_http_status :found
    end

    it 'タスクが削除されること' do
      expect(described_class.find_by(id: task.id)).to be_nil
    end

    it 'タスク一覧画面にリダイレクトされること' do
      expect(response).to redirect_to tasks_path
      # expect(response.body).to include "「#{task.name}」を削除しました"
    end
  end
end
