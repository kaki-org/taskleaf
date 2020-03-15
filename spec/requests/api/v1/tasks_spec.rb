# frozen_string_literal: true

require 'rails_helper'

describe 'タスクAPI', type: :request do
  context '作成したタスク' do
    let!(:task) { FactoryBot.create(:task, name: 'メイラーSpecを書く', description: '送信したメールの内容を確認します') }
    it '作成したタスクが返却される事' do
      get "/api/v1/tasks/#{task.id}", params: { 'HTTP_ACCEPT' => 'application/vnd.tasks.v1' }

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json['name']).to eq task.name
      expect(json['description']).to eq task.description
    end
    it '作成したタスクを更新できる事' do
      put "/api/v1/tasks/#{task.id}", params: { task: {
          name: 'MailerSpecを書く',
          description: '送信したMailの内容を確認します',
      }, 'HTTP_ACCEPT' => 'application/vnd.tasks.v1' }
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json['id']).to eq task.id
      expect(json['name']).to eq 'MailerSpecを書く'
      expect(json['description']).to eq '送信したMailの内容を確認します'
    end
  end
end
