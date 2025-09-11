# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :require_admin

    def index
      @users = if params[:limit].blank?
                 User.all
               else
                 User.limit(params[:limit])
               end
    end

    def show
      @user = User.find(params[:id])
    end

    def new
      @user = User.new
    end

    def edit
      @user = User.find(params[:id])
    end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to admin_user_url(@user), notice: "ユーザー「#{@user.name}」を登録しました"
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      @user = User.find(params[:id])

      if @user.update(user_params)
        redirect_to admin_user_url(@user), notice: "ユーザー「#{@user.name}」を更新しました"
      else
        render :edit, status: :unprocessable_content
      end
    end

    def confirm_destroy
      return if validate_user_own_request

      @user = User.find(params[:user_id])
    end

    def destroy
      return if validate_user_own_request

      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_users_url, notice: "ユーザー「#{@user.name}」を削除しました"
    end

    private

    def validate_user_own_request
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

    def require_admin
      redirect_to root_url unless current_user.admin?
    end
  end
end
