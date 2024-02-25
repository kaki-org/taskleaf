# frozen_string_literal: true

require 'rails_helper'

describe TasksController do
  describe 'CSV出力' do
    before do
      save_user_session create(:user)
    end

    it 'CSVファイルを返すこと' do
      get :index, params: { format: :csv }
      expect(response.headers['Content-Type']).to match 'text/csv'
    end

    it '中身を返すこと' do
      create(:task, name: 'title')
      expect(Task.last.name).to eq 'title'
    end
  end

  describe 'CSVインポート' do
    before do
      save_user_session create(:user)
    end

    it 'CSVファイルをアップロードしてインポートすること' do
      file = fixture_file_upload('tasks.csv', 'text/csv')
      expect do
        post :import, params: { file: }
      end.to change(Task, :count).by(1)
      expect(response).to redirect_to tasks_path
    end
  end
end
