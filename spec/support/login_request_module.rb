# frozen_string_literal: true

module LoginRequestModule
  def login_as(email, password)
    session_params = { email:, password: }
    post login_path, params: { session: session_params }
  end

  def login_by(user, password = 'Password@1234')
    login_as(user.email, password)
  end
end

RSpec.configure do |config|
  config.include LoginRequestModule, type: :request
end
