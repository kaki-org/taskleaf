# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Rails.env.production? && ENV['SEED_FORCE'] != 'true'
  Rails.logger.warn 'Skipping seeds.rb in production (set SEED_FORCE=true to override).'
  return
end

Rails.logger.debug 'Executing seeds.rb...'
admin_password = ENV.fetch('SEED_ADMIN_PASSWORD', 'password')
admin = User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.name = 'admin'
  user.admin = true
  user.password = admin_password
  user.password_confirmation = admin_password
end
50.times do |n|
  Task.find_or_create_by!(name: "テストタスク#{n + 1}", user: admin) do |task|
    task.description = "テストタスク#{n + 1}の詳細"
  end
end
20.times do |n|
  Task.find_by(name: "テストタスク#{n + 1}").image.attach(
    io: Rails.root.join('app/assets/images/onamae02.png').open, filename: 'onamae02.png'
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
  Task.find_or_create_by!(name: "テストタスク#{n + 51}") do |task|
    task.description = "テストタスク#{n + 51}の詳細"
    task.user_id = User.where(admin: false).ids.sample
  end
end
