# require 'rspec'
require 'rails_helper'

describe 'User' do
  # 名とメールとパスワードがあれば有効な状態であること
  it "is valid with a name and email and password" do
    user = User.new(
                   name: 'kakikubo',
                   email: 'kakikubo@gmail.com',
                   password: 'password',
    )
    expect(user).to be_valid
  end
  # 名がなければ無効な状態であること
  it "is invalid without a name"
  # メールアドレスがなければ無効な状態であること
  it "is invalid without a email"
  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address"
  # 連絡先のフルネームを文字列として返すこと
  it "return a users's name as a string"
  # before do
  #   # Do nothing
  # end
  #
  # after do
  #   # Do nothing
  # end
  #
  # context 'when condition' do
  #   it 'succeeds' do
  #     pending 'Not implemented'
  #   end
  # end
end