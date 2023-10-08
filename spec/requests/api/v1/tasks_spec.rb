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

    it '作成したタスクが返却される事' do
      get "/api/v1/tasks/#{task.id}", params: { 'HTTP_ACCEPT' => 'application/vnd.tasks.v1' }

      expect(response).to have_http_status(:success)

      json = response.parsed_body
      expect(json['name']).to eq task.name
      expect(json['description']).to eq task.description
    end

    it '作成したタスクを更新できる事' do
      put("/api/v1/tasks/#{task.id}", params:)
      expect(response).to have_http_status(:success)
      json = response.parsed_body
      expect(json['id']).to eq task.id
      expect(json['name']).to eq 'MailerSpecを書く'
      expect(json['description']).to eq '送信したMailの内容を確認します'
    end

    it '作成したタスクを削除できる事' do
      delete "/api/v1/tasks/#{task.id}"
      expect(response).to have_http_status(:success)
      expect(Task.find_by(id: task.id)).to be_nil
    end
  end
end
