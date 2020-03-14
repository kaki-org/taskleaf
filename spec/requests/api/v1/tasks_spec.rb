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
  end
end
