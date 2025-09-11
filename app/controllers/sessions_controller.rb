# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :login_required

  def new; end

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: I18n.t('login_success')
    else
      flash.now[:alert] = I18n.t('login_failed')
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    reset_session
    respond_to do |format|
      # status: :see_other が必須！！
      format.html { redirect_to root_url, notice: I18n.t('logout_success'), status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def session_params
    params.expect(session: %i[email password])
  end
end
