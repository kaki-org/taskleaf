# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  describe 'self-deletion prevention' do
    let(:admin_user) { create(:admin, name: 'Admin User') }
    let(:other_user) { create(:user, name: 'Other User') }

    before do
      save_user_session admin_user
    end

    describe 'GET #confirm_destroy' do
      context 'when trying to delete own account' do
        it 'redirects to admin users index with notice' do
          get :confirm_destroy, params: { user_id: admin_user.id }
          expect(response).to redirect_to(admin_users_url)
          expect(flash[:notice]).to eq(I18n.t('cannot_delete_yourself'))
        end
      end

      context 'when trying to delete another user account' do
        it 'allows access to confirm destroy page' do
          get :confirm_destroy, params: { user_id: other_user.id }
          expect(response).to be_successful
          expect(assigns(:user)).to eq(other_user)
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'when trying to delete own account' do
        it 'redirects to admin users index with notice' do
          expect { delete :destroy, params: { id: admin_user.id } }.not_to change(User, :count)
          expect(response).to redirect_to(admin_users_url)
          expect(flash[:notice]).to eq(I18n.t('cannot_delete_yourself'))
        end
      end

      context 'when trying to delete another user account' do
        it 'successfully deletes the user' do
          delete :destroy, params: { id: other_user.id }
          expect(response).to redirect_to(admin_users_url)
          expect(User.exists?(other_user.id)).to be false
        end
      end
    end
  end

  describe 'POST #create' do
    let(:admin_user) { create(:admin) }

    before do
      save_user_session admin_user
    end

    context 'with valid parameters' do
      let(:valid_params) do
        {
          name: 'New User',
          email: 'newuser@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      end

      it 'creates a new user' do
        expect do
          post :create, params: { user: valid_params }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the new user page' do
        post :create, params: { user: valid_params }
        expect(response).to redirect_to(admin_user_url(User.last))
        expect(flash[:notice]).to include('を登録しました')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          name: '',
          email: 'invalid-email',
          password: 'short',
          password_confirmation: 'different'
        }
      end

      it 'does not create a new user' do
        expect do
          post :create, params: { user: invalid_params }
        end.not_to change(User, :count)
      end

      it 'renders the new template' do
        post :create, params: { user: invalid_params }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #new' do
    let(:admin_user) { create(:admin) }

    before do
      save_user_session admin_user
    end

    it 'assigns a new user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    let(:admin_user) { create(:admin) }
    let(:user) { create(:user) }

    before do
      save_user_session admin_user
    end

    it 'assigns the requested user' do
      get :edit, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the edit template' do
      get :edit, params: { id: user.id }
      expect(response).to render_template(:edit)
    end
  end
end