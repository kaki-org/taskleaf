# frozen_string_literal: true

require 'rails_helper'

describe 'タスクAPI' do
  context '作成したタスクの場合' do
    let!(:task) { create(:task, name: 'メイラーSpecを書く', description: '送信したメールの内容を確認します') }
    let(:params) do
      {
        task: {
          name: 'MailerSpecを書く',
          description: '送信したMailの内容を確認します'
        }, 'HTTP_ACCEPT' => 'application/vnd.tasks.v1'
      }
    end

    it 'タスク作成が200で返却される事' do
      get "/api/v1/tasks/#{task.id}", params: { 'HTTP_ACCEPT' => 'application/vnd.tasks.v1' }

      expect(response).to have_http_status(:success)
    end

    it '404 Not Foundが返却されること' do
      get '/api/v1/tasks/999999', params: { 'HTTP_ACCEPT' => 'application/vnd.tasks.v1' }
      expect(response).to have_http_status(:not_found)
    end

    it '作成したタスク名が返却される事' do
      get "/api/v1/tasks/#{task.id}", params: { 'HTTP_ACCEPT' => 'application/vnd.tasks.v1' }
      json = response.parsed_body
      expect(json['name']).to eq task.name
    end

    it '作成したタスク内容が返却される事' do
      get "/api/v1/tasks/#{task.id}", params: { 'HTTP_ACCEPT' => 'application/vnd.tasks.v1' }
      json = response.parsed_body
      expect(json['description']).to eq task.description
    end

    it '作成したタスクの名前を更新すると200がかえってくること' do
      put("/api/v1/tasks/#{task.id}", params: { task: { name: 'MailerSpecを書く' } })
      expect(response).to have_http_status(:success)
    end

    it '作成したタスクの名前を更新できる事' do
      put("/api/v1/tasks/#{task.id}", params: { task: { name: 'MailerSpecを書く' } })
      json = response.parsed_body
      expect(json['name']).to eq 'MailerSpecを書く'
    end

    it '作成したタスクの説明を更新できる事' do
      put("/api/v1/tasks/#{task.id}", params: { task: { description: '送信したMailの内容を確認します' } })
      expect(response).to have_http_status(:success)
    end

    it '作成したタスクの説明が更新される事' do
      put("/api/v1/tasks/#{task.id}", params: { task: { description: '送信したMailの内容を確認します' } })
      json = response.parsed_body
      expect(json['id']).to eq task.id
    end

    it '作成したタスクの説明が正しく更新される事' do
      put("/api/v1/tasks/#{task.id}", params: { task: { description: '送信したMailの内容を確認します' } })
      json = response.parsed_body
      expect(json['description']).to eq '送信したMailの内容を確認します'
    end

    it '作成したタスクを削除できる事' do
      delete "/api/v1/tasks/#{task.id}"
      expect(response).to have_http_status(:success)
    end

    it '作成したタスクが削除される事' do
      delete "/api/v1/tasks/#{task.id}"
      expect(Task.find_by(id: task.id)).to be_nil
    end
  end
end
