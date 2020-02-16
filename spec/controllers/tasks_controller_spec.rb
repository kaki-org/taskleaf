# frozen_string_literal: true

require 'rails_helper'

# FIXME: このファイル自体が未完。ログイン処理が実装されたらp.70に戻って実装する
describe TasksController do
  describe 'CSV出力' do
    xit 'CSVファイルを返すこと' do
      get :index, params: { format: :csv }
      expect(response.headers['Content-Type']).to match 'text/csv'
    end
    xit '中身を返すこと' do
      create(:task, name: 'title')
    end
  end
end
