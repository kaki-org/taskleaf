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

      it '指定したIDのユーザーが正しく取得できる事' do
        get "/admin/users/#{user.id}"
        expect(assigns(:user)).to eq(user)
      end

      it 'ユーザーの詳細情報がレスポンスに含まれている事' do
        get "/admin/users/#{user.id}"
        expect(response.body).to include(user.name)
        expect(response.body).to include(user.email)
      end

      it '存在しないユーザIDを指定すると404が返ること' do
        get "/admin/users/#{User.last.id + 1}"
        expect(response.status).to eq 404
      end

      it 'ユーザ作成画面に遷移できる事' do
        get '/admin/users/new'
        expect(response).to have_http_status :ok
      end

      it '新しいユーザーオブジェクトが作成されること' do
        get '/admin/users/new'
        expect(assigns(:user)).to be_a_new(User)
      end

      it 'ユーザー作成フォームが表示されること' do
        get '/admin/users/new'
        expect(response.body).to include('ユーザー登録')
        expect(response.body).to include('名前')
        expect(response.body).to include('メールアドレス')
        expect(response.body).to include('パスワード')
        expect(response.body).to include('パスワード(確認)')
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

      it 'ユーザー作成成功時に詳細ページにリダイレクトすること' do
        params = {
          user: {
            name: 'ユーザーC',
            email: 'test3@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
        post('/admin/users', params:)
        expect(response).to redirect_to(admin_user_path(User.last))
      end

      it 'ユーザー作成成功時に正しいフラッシュメッセージが表示されること' do
        params = {
          user: {
            name: 'ユーザーC',
            email: 'test3@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
        post('/admin/users', params:)
        expect(flash[:notice]).to eq "ユーザー「ユーザーC」を登録しました"
      end

      it 'ユーザー作成失敗時に新規作成フォームが再表示されること' do
        params = {
          user: {
            name: '',
            email: 'test3@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
        post('/admin/users', params:)
        expect(response).to have_http_status :ok
        expect(response.body).to include('ユーザー登録')
      end

      it 'ユーザー作成失敗時にエラーメッセージが表示されること' do
        params = {
          user: {
            name: '',
            email: 'test3@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
        post('/admin/users', params:)
        expect(response.body).to include('名前を入力してください')
      end

      it 'ユーザー編集画面に遷移できる事' do
        get "/admin/users/#{user.id}/edit"
        expect(response).to have_http_status :ok
      end

      it '指定したIDのユーザーが正しく取得されること' do
        get "/admin/users/#{user.id}/edit"
        expect(assigns(:user)).to eq(user)
      end

      it 'ユーザー編集フォームが表示されること' do
        get "/admin/users/#{user.id}/edit"
        expect(response.body).to include('ユーザー編集')
        expect(response.body).to include('名前')
        expect(response.body).to include('メールアドレス')
        expect(response.body).to include('管理者権限')
        expect(response.body).to include('パスワード')
        expect(response.body).to include('パスワード(確認)')
        expect(response.body).to include('登録する')
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
