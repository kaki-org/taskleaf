# frozen_string_literal: true

RSpec.shared_context 'userでログイン済み' do
  before do
    login_as(user.email, 'password')
  end
end
RSpec.shared_context 'other_userでログイン済み' do
  before do
    login_as(other_user.email, 'password')
  end
end
