require 'rails_helper'

describe Admin::UsersController do
  describe 'GET #index' do
    let(:users) { FactoryBot.create_list :user, 2 }
    # params[:limitがある場合]
    context 'with params[:limit]' do
      # 与えられた件数のみ表示する事
      it "Show less than given number" do
        get :index, params: {limit: 1}
        expect(assigns(:users)).not_to match_array(:user2)
      end
      # :indexテンプレートを表示する事
      it "renders the :index template" do
        get :index, params: {limit: 1}
        expect(response).to render_template :index
      end
    end

    # params[:limit]がない場合
    context 'without params[:limit]' do
      # すべてのユーザが表示される事
      it "displays all users" do
        get :index
        expect(users.size).to eq(2)
      end
      # :index テンプレートを表示する事
      it "renders the :index template" do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #show' do
    # @user に要求された連絡先を割り当てる事
    it "assigns the requested user to @user" do
      user = create(:user)
      get :show, params: {id: user.id}
      expect(assigns(:user)).to eq user
    end
    # :show テンプレートを表示すること
    it "renders the :show template" do
      user = create(:user)
      get :show, params: {id: user.id}
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    # @user に新しいユーザを割り当てる事
    it "assigns a new User to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
    # :show テンプレートを表示すること
    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    # @user に要求されたユーザを割り当てる事
    it "assigns the requested user to @user" do
      user = create(:user)
      get :edit, params: {id: user}
      expect(assigns(:user)).to eq user
    end
    # :show テンプレートを表示すること
    it "renders the :edit template" do
      user = create(:user)
      get :edit, params: {id: user}
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before :each do
      @tasks = [
          attributes_for(:task),
          attributes_for(:task),
          attributes_for(:task)
      ]
    end
    # 有効な属性の場合
    context "with valid attributes" do
      # データベースに新しいユーザを保存する事
      it "saves the new user in the database" do
        expect {
          post :create, params: {user: attributes_for(:user, tasks_attributes: @tasks)}
        }.to change(User, :count).by(1)
      end
      # users#show にリダイレクトする事
      it "redirects to users#show" do
        post :create, params: {user: attributes_for(:user, tasks_attributes: @tasks)}
        expect(response).to redirect_to admin_user_url(assigns[:user])
      end
    end

    context "with invalid attributes" do
      # データベースに新しいユーザを保存しないこと
      it "does not save the new user in the database" do
        expect {
          post :create, params: {user: attributes_for(:user, :invalid_user)}
        }.not_to change(User, :count)
      end
      # :new テンプレートを再表示すること
      it "re-renders the :new template" do
        post :create, params: {user: attributes_for(:user, :invalid_user)}
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      @user = create(:user, name: 'kakikubo', email: 'kakikubo@example.com', password: 'password')
    end
    # 有効な属性の場合
    context "valid attributes" do
      # 要求された @user を取得すること
      it "locates the requested @user" do
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
      it "redirects to the updated contact" do
        patch :update, params: { id: @user, user: attributes_for(:user) }
        expect(response).to redirect_to admin_user_url(@user)
      end
    end

    # 無効な属性の場合
    context "with invalid attributes" do
      # ユーザーの属性を変更しないこと
      xit "does not change the user's attributes"
      # edit テンプレートを再表示する事
      xit "re-renders the edit template"
    end
  end

  describe 'DELETE #destroy' do
    # ユーザを削除する事
    xit "deletes the user"
    # user#index にリダイレクトすること
    xit "redirects to user#index"
  end
end