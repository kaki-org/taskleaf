# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :require_admin
    layout 'inertia'

    def index
      @users = if params[:limit].blank?
                 User.all
               else
                 User.limit(params[:limit])
               end
      render inertia: 'Admin/Users/Index', props: { users: @users.map { |user| user_props(user) } }
    end

    def show
      @user = User.find(params.expect(:id))
      render inertia: 'Admin/Users/Show', props: { user: user_props(@user) }
    end

    def new
      @user = User.new
      render inertia: 'Admin/Users/New'
    end

    def edit
      @user = User.find(params.expect(:id))
      render inertia: 'Admin/Users/Edit', props: { user: @user.slice(:id, :name, :email, :admin) }
    end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to admin_user_url(@user), notice: "ユーザー「#{@user.name}」を登録しました"
      else
        redirect_to new_admin_user_url, inertia: { errors: @user.errors.to_hash(true) }
      end
    end

    def update
      @user = User.find(params.expect(:id))

      if @user.update(user_params)
        redirect_to admin_user_url(@user), notice: "ユーザー「#{@user.name}」を更新しました"
      else
        redirect_to edit_admin_user_url(@user), inertia: { errors: @user.errors.to_hash(true) }
      end
    end

    def confirm_destroy
      return if user_own_request?

      @user = User.find(params.expect(:user_id))
      render inertia: 'Admin/Users/ConfirmDestroy', props: { user: user_props(@user) }
    end

    def destroy
      return if user_own_request?

      @user = User.find(params.expect(:id))
      @user.destroy
      redirect_to admin_users_url, notice: "ユーザー「#{@user.name}」を削除しました"
    end

    private

    def user_own_request?
      user_id = params[:id] || params[:user_id]
      if current_user.id == user_id.to_i
        redirect_to admin_users_url, notice: I18n.t('cannot_delete_yourself')
        return true
      end
      false
    end

    def user_params
      params.expect(user: %i[name email password password_confirmation])
    end

    def user_props(user)
      user.slice(:id, :name, :email, :admin).merge(created_at: user.created_at.to_s, updated_at: user.updated_at.to_s)
    end

    def require_admin
      redirect_to root_url unless current_user.admin?
    end
  end
end
