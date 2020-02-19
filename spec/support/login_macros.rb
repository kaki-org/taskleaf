# frozen_string_literal: true

module LoginMacros
  def save_user_session(user)
    session[:user_id] = user.id
  end
end
