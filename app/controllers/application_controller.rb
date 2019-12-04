# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user
  # before_action :login_required # FIXME: Controller Specをテストする間は一時的にコメントアウト

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to login_url unless current_user
  end
end
