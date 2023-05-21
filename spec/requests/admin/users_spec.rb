# frozen_string_literal: true

require 'rails_helper'

describe 'admin/users', type: :request do
  include_context 'userでログイン済み'
  let(:user) { FactoryBot.create(:user, admin: true, email: 'test@example.com', password: 'password') }
  let(:user2) { FactoryBot.create(:user, email: 'test2@example.com', password: 'password') }

  describe 'GET /admin/users' do
    before  { get '/admin/users' }

    context 'ログインしている場合' do
      it 'ユーザーの一覧が取得できる事' do
        expect(response.status).to eq 200
        expect(response.body).to include(user.name)
      end
      it 'ユーザ作成画面に遷移できる事' do
        get '/admin/users/new'
        expect(response.status).to eq 200
      end
      it 'ユーザーを作成できる事' do
        params = {
          user: {
            name: 'ユーザーB',
            email: 'test2@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
        post('/admin/users', params:)

        expect(response.status).to eq 302
        expect(User.last.name).to eq 'ユーザーB'
        expect(User.last.email).to eq 'test2@example.com'
      end
      it 'ユーザー編集画面に遷移できる事' do
        get "/admin/users/#{user2.id}/edit"
        expect(response.status).to eq 200
      end
      it 'ユーザーを更新できる事' do
        params = {
          user: {
            name: 'ユーザーBB',
            email: 'test22@example.com'
          }
        }
        patch("/admin/users/#{user2.id}", params:)
        expect(response.status).to eq 302
        expect(User.last.name).to eq 'ユーザーBB'
        expect(User.last.email).to eq 'test22@example.com'
      end
    end
  end
end
