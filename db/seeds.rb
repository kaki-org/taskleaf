# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts 'Executing seeds.rb...'
User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.name = 'admin'
  user.admin = true
  user.password = 'password'
  user.password_confirmation = 'password'
end
50.times do |n|
  Task.create!(
    name: "テストタスク#{n + 1}",
    description: "テストタスク#{n + 1}の詳細",
    user_id: 1
  )
end
20.times do |n|
  Task.find_by(name: "テストタスク#{n + 1}").image.attach(
    io: File.open(Rails.root.join('app/assets/images/onamae02.png')), filename: 'onamae02.png'
  )
end
5.times do |n|
  User.find_or_create_by!(email: "test#{n + 1}@example.com") do |user|
    user.name = "テスト太郎#{n + 1}"
    user.password = 'password'
    user.password_confirmation = 'password'
  end
end
100.times do |n|
  Task.create!(
    name: "テストタスク#{n + 1}",
    description: "テストタスク#{n + 1}の詳細",
    user_id: User.where(admin: false).ids.sample
  )
end
