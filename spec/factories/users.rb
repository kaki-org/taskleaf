# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    password { 'password' }
    email { Faker::Internet.email }

    after(:build) do |user|
      [:default_task, :mass_task, :society_task].each do |task|
        user.tasks << FactoryBot.build(:task,
                                       name: "test task name",
                                       description: task,
                                       user: user)
      end
    end

    factory :invalid_user do
      name nil
    end
  end

end
