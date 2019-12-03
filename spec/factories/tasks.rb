# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    association :user
    name { 'テストを書く' }

    factory :default_task do
      description { Faker::Lorem.sentence }
    end
    factory :mass_task do
      description { Faker::Lorem.sentence }
    end
    factory :society_task do
      description { Faker::Lorem.sentence }
    end
  end
end
