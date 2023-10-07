# frozen_string_literal: true

RSpec.shared_context 'userでログイン済みの時' do
  before do
    login_as(user.email, 'password')
  end
end

RSpec.shared_context 'other_userでログイン済みの時' do
  before do
    login_as(other_user.email, 'password')
  end
end
