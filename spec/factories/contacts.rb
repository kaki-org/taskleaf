# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    name { 'Sample Contact' }
    email { 'contact@example.com' }
  end
end
