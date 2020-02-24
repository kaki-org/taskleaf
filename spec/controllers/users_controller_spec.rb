# frozen_string_literal: true

require 'rails_helper'

describe Admin::UsersController do
  shared_examples 'public access to users' do
    describe 'GET #index' do
      context '参照しようとする' do
        it 'ルートへリダイレクト' do
          get :index
          expect(response).to redirect_to root_path
        end
      end
    end
  end
  shared_examples 'public access to guests' do
    describe 'GET #new 新規作成しようとして' do
      it 'ログインを要求すること' do
        get :new
        expect(response).to require_login
      end
    end
    describe 'GET #edit 編集しようとして' do
      it 'ログインを要求すること' do
        user = create(:user)
        get :edit, params: { id: user }
        expect(response).to require_login
      end
    end
    describe 'POST #create パラメータつきで新規作成しようとして' do
      it 'ログインを要求すること' do
        post :create, params: { id: create(:user),
                                user: attributes_for(:user) }
        expect(response).to require_login
      end
    end
    describe 'PATCH #update パラメータ付きで編集しようとして' do
      it 'ログインを要求すること' do
        put :update, params: { id: create(:user),
                               user: attributes_for(:user) }
        expect(response).to require_login
      end
    end
    describe 'DELETE #destroy 削除しようとして' do
      it 'ログインを要求すること' do
        delete :destroy, params: { id: create(:user) }
        expect(response).to require_login
      end
    end
  end
  shared_examples 'full access to users' do
    describe 'GET #index' do
      let!(:users) { FactoryBot.create_list :user, 2 }
      context 'params[:limit]がある場合' do
        # FIXME: ここのテストはおそらく正しい検証ができていない
        it '与えられた件数のみ表示する事' do
          get :index, params: { limit: 1 }
          expect(assigns(:users)).not_to match_array(users.last)
        end
        it ':indexテンプレートを表示する事' do
          get :index, params: { limit: 1 }
          expect(response).to render_template :index
        end
      end
      context 'params[:limit]がない場合' do
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
    describe 'GET #show' do
      let(:user1) { build_stubbed(:user, name: 'teruo', password: 'passoword', email: 'teruo@example.com')}
      # FIXME: p.105より。なるほど、よくわからん。
      before :each do
        allow(user1).to receive(:persisted?).and_return(true)
        allow(User).to receive(:order).with('name').and_return([user1])
        allow(User).to receive(:find).with(user1.id.to_s).and_return(user1)
        allow(user1).to receive(:save).and_return(true)
      end

      it '@user に要求されたを割り当てる事' do
        get :show, params: { id: user1 }
        expect(assigns(:user)).to eq user1
      end
      # :show テンプレートを表示すること
      it 'renders the :show template' do
        get :show, params: { id: user1 }
        expect(response).to render_template :show
      end
    end
    describe 'PATCH #update' do
      let(:user){
        create(:user, name: 'kakikubo', email: 'kakikubo@example.com', password: 'password')
      }
      # 有効な属性の場合
      context 'valid attributes' do
        # 要求された @user を取得すること
        it 'locates the requested @user' do
          patch :update, params: { id: user, user: attributes_for(:user) }
          expect(assigns(:user)).to eq(user)
        end
        # @userの属性を変更する事
        it "changes @user's attributes" do
          patch :update, params: { id: user, user: attributes_for(:user, name: 'user1') }
          user.reload
          expect(user.name).to eq('user1')
        end
        # 更新した連絡先のページへリダイレクトすること
        it 'redirects to the updated contact' do
          patch :update, params: { id: user, user: attributes_for(:user) }
          expect(response).to redirect_to admin_user_url(user)
        end
      end

      # 無効な属性の場合
      context 'with invalid attributes' do
        # ユーザーの属性を変更しないこと
        it "does not change the user's attributes" do
          patch :update, params: { id: user, user: attributes_for(:user, name: nil) }
          user.reload
          expect(user.name).to eq('kakikubo')
        end
        # edit テンプレートを再表示する事
        it 're-renders the edit template' do
          post :update, params: { id: user, user: attributes_for(:user, :invalid_user) }
          # FIXME: 本当は edit_admin_user_path(@user) としたかったが。。
          expect(response).to render_template 'admin/users/edit'
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:user){ create(:user)}
      # ユーザを削除する事
      it 'deletes the user' do
        expect do
          delete :destroy, params: { id: user }
        end.to change(User, :count).by(-1)
      end
      # user#index にリダイレクトすること
      it 'redirects to user#index' do
        delete :destroy, params: { id: user }
        expect(response).to redirect_to admin_users_url
      end
    end
  end
  describe 'administrator access' do
    before :each do
      save_user_session create(:admin)
    end
    it_behaves_like 'full access to users'
  end
  describe '一般ユーザでのアクセス' do
    before :each do
      save_user_session create(:user)
    end
    it_behaves_like 'public access to users'
  end
  describe 'ゲストユーザでのアクセス' do
    it_behaves_like 'public access to guests'
  end
end
