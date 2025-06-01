# frozen_string_literal: true

require 'rails_helper'

describe 'admin/users' do
  include_context 'admin_userでログイン済みの時'
  let(:admin_user) { create(:user, admin: true, email: 'test@example.com', password: 'password') }
  let(:user) { create(:user, admin: false, email: 'test2@example.com', password: 'password') }

  describe 'GET /admin/users' do
    context 'ユーザー一覧' do
      before { get '/admin/users' }

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
    end

    context 'ユーザー詳細' do
      context '存在するユーザーの場合' do
        before { get "/admin/users/#{user.id}" }

        it 'okがかえってくること' do
          expect(response).to have_http_status :ok
        end

        it '指定したIDのユーザーが正しく取得できる事' do
          expect(assigns(:user)).to eq(user)
        end

        it 'ユーザーの詳細情報がレスポンスに含まれている事' do
          expect(response.body).to include(user.name)
          expect(response.body).to include(user.email)
        end
      end

      context '存在しないユーザーの場合' do
        it '404が返ること' do
          get "/admin/users/#{User.last.id + 1}"
          expect(response.status).to eq 404
        end
      end
    end

    context 'ユーザー新規作成画面' do
      before { get '/admin/users/new' }

      it 'okがかえってくること' do
        expect(response).to have_http_status :ok
      end

      it '新しいユーザーオブジェクトが作成されること' do
        expect(assigns(:user)).to be_a_new(User)
      end

      it 'ユーザー作成フォームが表示されること' do
        expect(response.body).to include('ユーザー登録')
        expect(response.body).to include('名前')
        expect(response.body).to include('メールアドレス')
        expect(response.body).to include('パスワード')
        expect(response.body).to include('パスワード(確認)')
      end
    end

    context 'ユーザー編集画面' do
      before { get "/admin/users/#{user.id}/edit" }

      it 'okがかえってくること' do
        expect(response).to have_http_status :ok
      end

      it '指定したIDのユーザーが正しく取得されること' do
        expect(assigns(:user)).to eq(user)
      end

      it 'ユーザー編集フォームが表示されること' do
        expect(response.body).to include('ユーザー編集')
        expect(response.body).to include('名前')
        expect(response.body).to include('メールアドレス')
        expect(response.body).to include('管理者権限')
        expect(response.body).to include('パスワード')
        expect(response.body).to include('パスワード(確認)')
        expect(response.body).to include('登録する')
      end
    end

    context 'ユーザー削除確認画面' do
      before { get "/admin/users/#{user.id}/confirm_destroy" }

      it 'okがかえってくること' do
        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'POST /admin/users' do
    let(:valid_params) do
      {
        user: {
          name: 'ユーザーC',
          email: 'test3@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end

    let(:invalid_params) do
      {
        user: {
          name: '',
          email: 'test3@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end

    let(:duplicate_email_params) do
      {
        user: {
          name: 'ユーザーA',
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end

    context '正常なパラメータの場合' do
      before { post('/admin/users', params: valid_params) }

      it 'foundがかえってくること' do
        expect(response).to have_http_status :found
      end

      it 'ユーザーが作成され、nameが正しいこと' do
        expect(User.last.name).to eq 'ユーザーC'
      end

      it 'ユーザーが作成され、emailが正しいこと' do
        expect(User.last.email).to eq 'test3@example.com'
      end

      it '詳細ページにリダイレクトすること' do
        expect(response).to redirect_to(admin_user_path(User.last))
      end

      it '正しいフラッシュメッセージが表示されること' do
        expect(flash[:notice]).to eq "ユーザー「ユーザーC」を登録しました"
      end
    end

    context '不正なパラメータの場合' do
      context '必須項目が空の場合' do
        before { post('/admin/users', params: invalid_params) }

        it '新規作成フォームが再表示されること' do
          expect(response).to have_http_status :ok
          expect(response.body).to include('ユーザー登録')
        end

        it 'エラーメッセージが表示されること' do
          expect(response.body).to include('名前を入力してください')
        end
      end

      context 'メールアドレスが重複している場合' do
        it 'ユーザーが作成されないこと' do
          expect { post('/admin/users', params: duplicate_email_params) }.not_to change(User, :count)
        end
      end
    end
  end

  describe 'PATCH /admin/users/:id' do
    let(:valid_update_params) do
      {
        user: {
          name: 'ユーザーBB',
          email: 'test22@example.com'
        }
      }
    end

    let(:invalid_update_params) do
      {
        user: {
          name: 'ユーザーBB',
          email: ''
        }
      }
    end

    context '正常なパラメータの場合' do
      before { patch("/admin/users/#{user.id}", params: valid_update_params) }

      it 'foundがかえってくること' do
        expect(response).to have_http_status :found
      end

      it 'ユーザーが更新され、nameが正しいこと' do
        expect(User.last.name).to eq 'ユーザーBB'
      end

      it 'ユーザーが更新され、emailが正しいこと' do
        expect(User.last.email).to eq 'test22@example.com'
      end

      it '詳細ページにリダイレクトすること' do
        expect(response).to redirect_to(admin_user_path(user))
      end

      it '正しいフラッシュメッセージが表示されること' do
        expect(flash[:notice]).to eq "ユーザー「ユーザーBB」を更新しました"
      end
    end

    context '不正なパラメータの場合' do
      before { patch("/admin/users/#{user.id}", params: invalid_update_params) }

      it 'okがかえってくること' do
        expect(response).to have_http_status :ok
      end

      it 'ユーザーが更新されないこと' do
        expect(User.last.email).to eq 'test2@example.com'
      end

      it '編集フォームが再表示されること' do
        expect(response.body).to include('ユーザー編集')
      end

      it 'エラーメッセージが表示されること' do
        expect(response.body).to include('メールアドレスを入力してください')
      end
    end
  end

  describe 'DELETE /admin/users/:id' do
    before { delete "/admin/users/#{user.id}" }

    it 'foundがかえってくること' do
      expect(response).to have_http_status :found
    end

    it 'ユーザーが削除されること' do
      expect(User.last.email).to eq 'test@example.com'
    end
  end
end
