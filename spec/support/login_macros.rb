# frozen_string_literal: true

module LoginMacros
  def set_user_session(user)
    session[:user_id] = user.id
  end
end
