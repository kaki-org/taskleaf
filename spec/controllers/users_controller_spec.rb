# frozen_string_literal: true

require 'rails_helper'

describe Admin::UsersController do
  shared_examples 'public access to users' do
    describe 'GET #index' do
      let(:users) { FactoryBot.create_list :user, 2 }
      # params[:limitがある場合]
      context 'with params[:limit]' do
        # 与えられた件数のみ表示する事
        it 'Show less than given number' do
          get :index, params: { limit: 1 }
          expect(assigns(:users)).not_to match_array(:user2)
        end
        # :indexテンプレートを表示する事
        it 'renders the :index template' do
          get :index, params: { limit: 1 }
          expect(response).to render_template :index
        end
      end
      # params[:limit]がない場合
      context 'without params[:limit]' do
        # すべてのユーザが表示される事
        it 'displays all users' do
          get :index
          expect(users.size).to eq(2)
        end
        # :index テンプレートを表示する事
        it 'renders the :index template' do
          get :index
          expect(response).to render_template :index
        end
      end
    end

  end
  shared_examples 'full access to users' do
    describe 'GET #show' do
      # @user に要求された連絡先を割り当てる事
      it 'assigns the requested user to @user' do
        user = create(:user)
        get :show, params: { id: user.id }
        expect(assigns(:user)).to eq user
      end
      # :show テンプレートを表示すること
      it 'renders the :show template' do
        user = create(:user)
        get :show, params: { id: user.id }
        expect(response).to render_template :show
      end
    end
    describe 'PATCH #update' do
      before :each do
        @user = create(:user, name: 'kakikubo', email: 'kakikubo@example.com', password: 'password')
      end
      # 有効な属性の場合
      context 'valid attributes' do
        # 要求された @user を取得すること
        it 'locates the requested @user' do
          patch :update, params: { id: @user, user: attributes_for(:user) }
          expect(assigns(:user)).to eq(@user)
        end
        # @userの属性を変更する事
        it "changes @user's attributes" do
          patch :update, params: { id: @user, user: attributes_for(:user, name: 'teruo') }
          @user.reload
          expect(@user.name).to eq('teruo')
        end
        # 更新した連絡先のページへリダイレクトすること
        it 'redirects to the updated contact' do
          patch :update, params: { id: @user, user: attributes_for(:user) }
          expect(response).to redirect_to admin_user_url(@user)
        end
      end

      # 無効な属性の場合
      context 'with invalid attributes' do
        # ユーザーの属性を変更しないこと
        it "does not change the user's attributes" do
          patch :update, params: { id: @user, user: attributes_for(:user, name: nil) }
          @user.reload
          expect(@user.name).to eq('kakikubo')
        end
        # edit テンプレートを再表示する事
        xit 're-renders the edit template' do # FIXME: ここだけうまくいってない
          post :update, params: { id: @user, user: attributes_for(:user, :invalid_user) }
          expect(response).to render_template edit_admin_user_path(@user)
        end
      end
    end

    describe 'DELETE #destroy' do
      before :each do
        @user = create(:user)
      end
      # ユーザを削除する事
      it 'deletes the user' do
        expect  do
          delete :destroy, params: { id: @user }
        end.to change(User, :count).by(-1)
      end
      # user#index にリダイレクトすること
      it 'redirects to user#index' do
        delete :destroy, params: { id: @user }
        expect(response).to redirect_to admin_users_url
      end
    end
  end
  describe 'administrator access' do
    before :each do
      user = create(:admin)
      session[:user_id] = user.id
    end
    it_behaves_like 'public access to users'
    it_behaves_like 'full access to users'
  end
  describe '一般ユーザでのアクセス' do
    before :each do
      user = create(:user)
      session[:user_id] = user.id
    end
    it_behaves_like 'public access to users'
  end
  describe 'ゲストユーザでのアクセス' do
    it_behaves_like 'public access to users'
    describe 'GET #new 新規作成しようとして' do
      it 'ログインを要求すること' do
        get :new
        expect(response).to redirect_to login_url
      end
    end
    describe 'GET #edit 編集しようとして' do
      it 'ログインを要求すること' do
        user = create(:user)
        get :edit, params: { id: user }
        expect(response).to redirect_to login_url
      end
    end
    describe 'POST #create パラメータつきで新規作成しようとして' do
      it 'ログインを要求すること' do
        post :create, params: { id: create(:user),
                                user: attributes_for(:user) }
        expect(response).to redirect_to login_url
      end
    end
    describe 'PATCH #update パラメータ付きで編集しようとして' do
      it 'ログインを要求すること' do
        put :update, params: { id: create(:user),
                               user: attributes_for(:user) }
        expect(response).to redirect_to login_url
      end
    end
    describe 'DELETE #destroy 削除しようとして' do
      it 'ログインを要求すること' do
        delete :destroy, params: { id: create(:user) }
        expect(response).to redirect_to login_url
      end
    end
  end
end
