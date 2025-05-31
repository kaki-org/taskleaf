# frozen_string_literal: true

require 'rails_helper'

describe 'admin/users' do
  include_context 'admin_userでログイン済みの時'
  let(:admin_user) { create(:user, admin: true, email: 'test@example.com', password: 'password') }
  let(:user) { create(:user, admin: false, email: 'test2@example.com', password: 'password') }

  describe 'GET /admin/users' do
    before  { get '/admin/users' }

    context 'ログインしている場合' do
      it 'okがかえってくること' do
        expect(response).to have_http_status :ok
      end

      it 'ユーザーの一覧が取得できる事' do
        expect(response.body).to include(admin_user.name)
      end

      it 'limitパラメータが空の場合、全てのユーザーが取得できる事' do
        create_list(:user, 3)
        expect(assigns(:users).count).to eq(User.count)
      end

      it 'limitパラメータを使ってユーザーの一覧が制限されて取得できる事' do
        create_list(:user, 3)
        get '/admin/users', params: { limit: 2 }
        expect(assigns(:users).count).to eq(2)
      end

      it 'ユーザーの詳細画面に遷移できる事' do
        get "/admin/users/#{admin_user.id}"
        expect(response).to have_http_status :ok
      end

      it 'ユーザ作成画面に遷移できる事' do
        get '/admin/users/new'
        expect(response).to have_http_status :ok
      end

      it 'ユーザー作成時にfoundがかえってくること' do
        params = {
          user: {
            name: 'ユーザーB',
            email: 'test2@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
        post('/admin/users', params:)

        expect(response).to have_http_status :found
      end

      it 'ユーザーを作成でき、nameがただしい事' do
        params = {
          user: {
            name: 'ユーザーB',
            email: 'test2@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
        post('/admin/users', params:)

        expect(User.last.name).to eq 'ユーザーB'
      end

      it 'ユーザーを作成できemailが正しい事' do
        params = {
          user: {
            name: 'ユーザーB',
            email: 'test2@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
        post('/admin/users', params:)

        expect(User.last.email).to eq 'test2@example.com'
      end

      it 'ユーザーの作成に失敗する事' do
        params = {
          user: {
            name: 'ユーザーA',
            email: 'test@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
        expect { post('/admin/users', params:) }.not_to change(User, :count)
      end

      it 'ユーザー編集画面に遷移できる事' do
        get "/admin/users/#{user.id}/edit"
        expect(response).to have_http_status :ok
      end

      it 'ユーザーを更新できfoundがかえってくる事' do
        params = {
          user: {
            name: 'ユーザーBB',
            email: 'test22@example.com'
          }
        }
        patch("/admin/users/#{user.id}", params:)
        expect(response).to have_http_status :found
      end

      it 'ユーザーを更新でき、nameが正しい事' do
        params = {
          user: {
            name: 'ユーザーBB',
            email: 'test22@example.com'
          }
        }
        patch("/admin/users/#{user.id}", params:)
        expect(User.last.name).to eq 'ユーザーBB'
      end

      it 'ユーザーを更新でき、emailが正しい事' do
        params = {
          user: {
            name: 'ユーザーBB',
            email: 'test22@example.com'
          }
        }
        patch("/admin/users/#{user.id}", params:)
        expect(User.last.email).to eq 'test22@example.com'
      end

      it 'ユーザーの更新に失敗してもokが返ってくること' do
        params = {
          user: {
            name: 'ユーザーBB',
            email: ''
          }
        }
        patch("/admin/users/#{user.id}", params:)
        expect(response).to have_http_status :ok
      end

      it 'ユーザーの更新に失敗する事' do
        params = {
          user: {
            name: 'ユーザーBB',
            email: ''
          }
        }
        patch("/admin/users/#{user.id}", params:)
        expect(User.last.email).to eq 'test2@example.com'
      end

      it 'ユーザの削除確認画面に遷移できる事' do
        get "/admin/users/#{user.id}/confirm_destroy"
        expect(response).to have_http_status :ok
      end

      it 'ユーザー削除時のレスポンスがfoundであること' do
        delete "/admin/users/#{user.id}"
        expect(response).to have_http_status :found
      end

      it 'ユーザーを削除できる事' do
        delete "/admin/users/#{user.id}"
        expect(User.last.email).to eq 'test@example.com'
      end
    end
  end
end
