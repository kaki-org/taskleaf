# frozen_string_literal: true

# require 'rspec'
require 'rails_helper'

describe 'User' do
  # 名とメールとパスワードがあれば有効な状態であること
  it 'is valid with a name and email and password' do
    user = User.new(
      name: 'kakikubo',
      email: 'kakikubo@gmail.com',
      password: 'password'
    )
    expect(user).to be_valid
  end
  # 名がなければ無効な状態であること
  it 'is invalid without a name' do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include('を入力してください')
  end
  # メールアドレスがなければ無効な状態であること
  it 'is invalid without a email' do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include('を入力してください')
  end
  # 重複したメールアドレスなら無効な状態であること
  it 'is invalid with a duplicate email address' do
    FactoryBot.create(:user, name: 'kakikubo', email: 'kakikubo@gmail.com')
    user = FactoryBot.build(:user, name: 'teruo', email: 'kakikubo@gmail.com')
    user.valid?
    expect(user.errors[:email]).to include('はすでに存在します')
  end
  # 有効なファクトリを持つこと
  it 'has a valid factory' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  # 文字列で名前をフィルタする
  describe 'filter name by letter' do
    before :each do
      @smith = User.create(
        name: 'Smith',
        email: 'jsmith@example.com',
        password: 'password'
      )
      @jones = User.create(
        name: 'Jones',
        email: 'tjones@example.com',
        password: 'password'
      )
      @johnson = User.create(
        name: 'Johnson',
        email: 'jjohnson@example.com',
        password: 'password'
      )
    end
    # マッチした結果をソート済みの配列として返すこと
    context 'matching letters' do
      it 'returns a sorted array of results that match' do
        expect(User.by_letter('J')).to eq [@johnson, @jones]
      end
    end
    # マッチしなかったものは結果に含まれないこと
    context 'non-matching letters' do
      it 'returns a sorted array of results that match' do
        expect(User.by_letter('J')).not_to include @smith
      end
    end
  end
end
