# frozen_string_literal: true

require 'rails_helper'

describe Task, type: :request do
  describe 'GET /tasks' do
    context 'ログインしている場合' do
      include_context 'userでログイン済み'
      let(:user) { FactoryBot.create(:user, admin: true, email: 'test@example.com', password: 'password') }
      let(:user2) { FactoryBot.create(:user, email: 'test2@example.com', password: 'password') }
      let!(:task_a) { create(:task, name: '最初のタスク', user:) }
      let!(:task_b) { create(:task, name: '次のタスク', user:) }
      let!(:task_c) { create(:task, name: '最後のタスク', user:) }
      context '通常のタスク一覧' do
        before { get '/tasks' }
        it 'タスクの一覧が取得できる事' do
          expect(response.status).to eq 200
          expect(response.body).to include '最初のタスク'
          expect(response.body).to include '次のタスク'
          expect(response.body).to include '最後のタスク'
        end
        it '通常は画面上にバースデーメッセージが出力されない' do
          expect(response.body).not_to include 'お誕生日おめでとうございます'
        end
      end
      context '特別な日の判定' do
        before do
          travel_to(Time.parse('2020-03-13')) do
            get '/tasks'
          end
        end
        it '誕生日には画面上にバースデーメッセージが出力される' do
          expect(response.body).to include 'お誕生日おめでとうございます'
        end
      end
    end
    context 'ログインしていない場合' do
      describe 'GET /tasks' do
        before { get '/tasks' }
        it 'ログイン画面に遷移する事' do
          expect(response.status).to eq 302
          expect(response).to require_login
        end
      end
    end
  end

  describe '新規作成機能' do
    include_context 'userでログイン済み'
    let(:user) { FactoryBot.create(:user, admin: true, email: 'admin@example.com', password: 'password') }
    let(:task_params) { FactoryBot.attributes_for(:task) }

    before do
      post tasks_path, params: { task: task_params }
    end
    it 'タスクを作成できる事' do
      expect(response.status).to eq 302
      expect(Task.last.name).to eq task_params[:name]
    end
    it 'メールが送信される事' do
      sender = ActionMailer::Base.deliveries.last.from
      expect(last_email).to be_delivered_from sender
      expect(last_email).to be_delivered_to 'user@example.com'
      expect(last_email).to be_delivered_from 'taskleaf@example.com'
      expect(last_email).to have_subject 'タスク作成完了メール'
      expect(last_email).to have_body_text '以下のタスクを作成しました'
    end
  end
end
