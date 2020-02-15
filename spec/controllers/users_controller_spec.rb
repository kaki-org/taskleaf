require 'rails_helper'

describe Admin::UsersController do
  describe 'GET #index' do
    # params[:limitがある場合]
    context 'with params[:limit]' do
      # 与えられた件数のみ表示する事
      xit "Show less than given number"
      # :indexテンプレートを表示する事
      it "renders the :index template"
    end

    # params[:limit]がない場合
    context 'without params[:limit]' do
      # すべてのユーザを配列にまとめる事
      xit "populates an array of all users"
      # :index テンプレートを表示する事
      xit "renders the :index template"
    end
  end

  describe 'GET #show', type: :ctr do
    # @user に要求された連絡先を割り当てる事
    it "assigns the requested user to @user" do
      user = create(:user)
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq user
    end
    # :show テンプレートを表示すること
    it "renders the :show template" do
      user = create(:user)
      get :show,  params: { id: user.id }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    # @user に新しいユーザを割り当てる事
    xit "assigns a new User to @user"
    # :show テンプレートを表示すること
    xit "renders the :new template"
  end

  describe 'GET #edit' do
    # @user に要求された連絡先を割り当てる事
    xit "assigns the requested user to @user"
    # :show テンプレートを表示すること
    xit "renders the :edit template"
  end

  describe 'POST #create' do
    # 有効な属性の場合
    context "with valid attributes" do
      # データベースに新しいユーザを保存する事
      xit "saves the new user in the database"
      # contacts#show にリダイレクトする事
      xit "redirects to contacts#show"
    end

    context "with invalid attributes" do
      # データベースに新しい連絡先を保存しないこと
      xit "does not save the new user in the database"
      # :new テンプレートを再表示すること
      xit "re-renders the :new template"
    end
  end

  describe 'PATCH #update' do
    # 有効な属性の場合
    context "valid attributes" do
      # 要求された @user を取得すること
      xit "locates the requested @user"
      # @userの属性を変更する事
      xit "changes @user's attributes"
      # 更新した連絡先のページへリダイレクトすること
      xit "redirects to the updated contact"
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