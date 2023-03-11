# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0.2'
# Use postgresql as the database for Active Record
# Use Puma as the app server
gem 'puma', '~> 6.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.17'

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

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'brakeman', require: false
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'guard-rspec'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 6.0'
  gem 'rubocop'
  gem 'spring-commands-rspec'
end

group :development do
  gem 'email_spec'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'foreman'
  gem 'listen', '>= 3.0.5', '< 3.9'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.1.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'faker'

  gem 'selenium-webdriver'
  gem 'launchy'
  # Easy installation and use of chromedriver to run system tests with Chrome
  # gem 'chromedriver-helper' # 2019/03/31?あたりからこいつは非推奨(Capybaraとかでコケまくる。webdriversを利用する)
  # gem 'webdrivers', require: !ENV['SELENIUM_DRIVER_URL']
  gem 'rails-controller-testing'
  gem 'simplecov', require: false
  gem 'simplecov-lcov', require: false
  # gem 'codecov'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'bootstrap'
gem 'html2slim'
gem 'kaminari'
gem 'rails_autolink' # TODO : rinkuに置き換えたい
gem 'ransack'
gem 'sidekiq'
gem 'slim-rails'
gem 'sass-rails'

gem 'pg', '~> 1.4'
