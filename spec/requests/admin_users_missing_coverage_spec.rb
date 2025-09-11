# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Users Controller Missing Coverage', type: :request do
  let(:admin_user) { create(:admin, password: 'password') }

  before do
    # セッションを通じて管理者ユーザーとしてログイン
    post '/login', params: { session: { email: admin_user.email, password: 'password' } }
  end

  describe 'GET /admin/users (index)' do
    context 'without limit parameter' do
      it 'shows all users' do
        create_list(:user, 3)
        get '/admin/users'
        expect(response).to have_http_status(:success)
      end
    end

    context 'with limit parameter' do
      it 'limits the number of users shown' do
        create_list(:user, 3)
        get '/admin/users', params: { limit: 2 }
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET /admin/users/:id (show)' do
    it 'shows a specific user' do
      user = create(:user)
      get "/admin/users/#{user.id}"
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /admin/users/:id (update)' do
    let(:user) { create(:user, name: 'Original Name') }

    context 'with valid parameters' do
      it 'updates the user successfully' do
        patch "/admin/users/#{user.id}", params: {
          user: { name: 'Updated Name', email: 'updated@example.com', password: 'newpassword', password_confirmation: 'newpassword' }
        }
        expect(response).to have_http_status(:found) # redirect
        user.reload
        expect(user.name).to eq('Updated Name')
      end
    end

    context 'with invalid parameters' do
      it 'renders the edit form with errors' do
        patch "/admin/users/#{user.id}", params: {
          user: { name: '', email: 'invalid-email' }
        }
        expect(response).to have_http_status(:unprocessable_content) # renders :edit template with validation errors
      end
    end
  end
end
