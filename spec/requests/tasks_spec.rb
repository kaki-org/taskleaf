# frozen_string_literal: true

require 'rails_helper'

describe Task, type: :request do
  context 'ログインしている場合' do
    include_context 'userでログイン済み'
    let(:user) { FactoryBot.create(:user, admin: true, email: 'test@example.com', password: 'password') }
    let(:user2) { FactoryBot.create(:user, email: 'test2@example.com', password: 'password') }
    let!(:task_a) { create(:task, name: '最初のタスク', user:) }
    let!(:task_b) { create(:task, name: '次のタスク', user:) }
    let!(:task_c) { create(:task, name: '最後のタスク', user:) }
    describe 'GET /tasks' do
      before { get '/tasks' }
      it 'タスクの一覧が取得できる事' do
        expect(response.status).to eq 200
        expect(response.body).to include '最初のタスク'
        expect(response.body).to include '次のタスク'
        expect(response.body).to include '最後のタスク'
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
