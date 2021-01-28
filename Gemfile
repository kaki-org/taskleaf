# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 5.2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.16'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'brakeman', require: false
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'debase'
  gem 'factory_bot_rails', '~> 6.1'
  gem 'guard-rspec'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 4.0'
  gem 'rubocop'
  gem 'ruby-debug-ide'
  gem 'spring-commands-rspec'
end

group :development do
  gem 'email_spec'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'foreman'
  gem 'listen', '>= 3.0.5', '< 3.5'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'faker'

  gem 'selenium-webdriver'
  gem 'launchy'
  # Easy installation and use of chromedriver to run system tests with Chrome
  # gem 'chromedriver-helper' # 2019/03/31?あたりからこいつは非推奨(Capybaraとかでコケまくる。webdriversを利用する)
  gem 'webdrivers'
  gem 'rails-controller-testing'
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
gem 'webpacker'
