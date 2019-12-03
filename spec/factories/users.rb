# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    password { 'password' }
    email { Faker::Internet.email }
  end
end
