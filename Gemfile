# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.2.0'
# Use postgresql as the database for Active Record
# Use Puma as the app server
gem 'puma', '~> 6.4'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.17'

gem 'cssbundling-rails'
gem 'jsbundling-rails'
gem 'sprockets-rails'

# gem 'hotwire-rails'
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'net-smtp', require: false

# modular monolith support tool
gem 'packs-rails'
gem 'packwerk'
gem 'packwerk-extensions'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'brakeman', require: false
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'guard-rspec'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 6.0'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'spring-commands-rspec'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'foreman'
  gem 'listen', '>= 3.0.5', '< 3.10'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.1.0'
end

group :test do
  gem 'capybara'
  gem 'capybara-playwright-driver'
  gem 'email_spec'
  gem 'faker'

  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '~> 6.0'
  gem 'simplecov', require: false
  gem 'simplecov-lcov', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'bootstrap'
gem 'html2slim'
gem 'kaminari'
gem 'rails_autolink' # TODO : rinkuに置き換えたい
gem 'ransack'
gem 'sass-rails'
gem 'sidekiq'
gem 'slim-rails'

gem 'pg', '~> 1.5'
