# frozen_string_literal: true

require 'rails_helper'

describe TasksController do
  describe 'CSV出力' do
    before :each do
      save_user_session create(:user)
    end
    it 'CSVファイルを返すこと' do
      get :index, params: { format: :csv }
      expect(response.headers['Content-Type']).to match 'text/csv'
    end
    it '中身を返すこと' do
      create(:task, name: 'title')
    end
  end
end
