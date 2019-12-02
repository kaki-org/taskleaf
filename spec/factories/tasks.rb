# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    association :user
    name { 'テストを書く' }

    factory :default_task do
      description { 'RSpec&Capybara&FactoryBotを準備する' }
    end
    factory :mass_task do
      description { '数学のFactoryBotを準備する' }
    end
    factory :society_task do
      description { '社会科のFactoryBotを準備する'}
    end
  end
end
