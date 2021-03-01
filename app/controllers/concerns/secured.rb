module Secured
  extend ActiveSupport::Concern

  included do
    before_action :login_required
  end

  def current_user
    return @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    return @current_user ||= User.find_by(email: session[:userinfo]['info']['email']) if session[:userinfo].present?
  end

  def login_required
    redirect_to login_url unless current_user
  end
end