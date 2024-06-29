# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions' do
  describe 'GET /sessions/new' do
    before { get '/login' }

    it 'okが表示されること' do
      expect(response).to have_http_status :ok
    end

    it 'ログイン画面が表示されること' do
      expect(response.body).to include 'ログイン'
    end
  end

  describe 'POST /sessions' do
    let(:user) { create(:user, email: 'admin@example.com', password: 'password') }

    context 'パラメータが正常な場合' do
      before { post '/login', params: { session: { email: user.email, password: user.password } } }

      it 'root_pathへリダイレクトされること' do
        expect(response).to redirect_to root_path
      end

      it 'ログインできること' do
        expect(session[:user_id]).to eq user.id
      end
    end

    context 'パラメータが異常な場合' do
      before { post '/login', params: { session: { email: user.email, password: 'invalid_password' } } }

      it 'unprocessable_entityがかえってくること' do
        expect(response).to be_unprocessable
      end

      it 'ログインできないこと' do
        expect(session[:user_id]).to be_nil
      end
    end
  end

  describe 'DELETE /sessions' do
    let(:user) { create(:user, email: 'admin@example.com', password: 'password') }

    before do
      post '/login', params: { session: { email: user.email, password: user.password } }
      delete '/logout'
    end

    it 'root_pathへリダイレクトされること' do
      expect(response).to redirect_to root_path
    end

    it 'ログアウトできること' do
      expect(session[:user_id]).to be_nil
    end
  end
end
