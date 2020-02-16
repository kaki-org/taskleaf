require 'rails_helper'

describe TasksController do
  describe 'CSV出力' do
    it 'CSVファイルを返すこと' do
      get :index, params: { format: :csv }
      expect(response.headers['Content-Type']).to match 'text/csv'
    end
    xit '中身を返すこと' do
      create(:task, name: 'title' )
    end
  end
end