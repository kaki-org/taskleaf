# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'capybara/rails'
require 'selenium-webdriver'
require 'email_spec'

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  # RSpec 3.8.0から
  config.render_views
  # ファクトリを簡単に呼び出せるよう、FactoryBot の構文をインクルードする
  config.include FactoryBot::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures" # 使わないので削除

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 120 # instead of the default 60

  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  Capybara.register_driver :remote_chrome do |app|
    caps = ::Selenium::WebDriver::Options.chrome(
      'goog:chromeOptions' => {
        'args' => %w[no-sandbox headless disable-gpu window-size=1680,1050 lang=ja]
      }
    )
    if ENV['SELENIUM_DRIVER_URL'].present?
      Capybara::Selenium::Driver.new(app, browser: :remote, url: ENV['SELENIUM_DRIVER_URL'], options: caps).tap do |driver|
        # NOTE: chrome(v77未満)用にダウンロードディレクトリを設定
        driver.browser.download_path = DownloadHelper::PATH.to_s
      end
    else
      Capybara::Selenium::Driver.new(app, browser: :chrome, options: caps).tap do |driver|
        # NOTE: chrome(v77未満)用にダウンロードディレクトリを設定
        driver.browser.download_path = DownloadHelper::PATH.to_s
      end
    end
    # options = ::Selenium::WebDriver::Chrome::Options.new
    #
    # options.add_argument('--no-sandbox')
    # options.add_argument('--lang=ja-JP')
    # options.add_argument('--headless')
    # options.add_argument('--disable-gpu')
    # options.add_argument('--disable-dev-shm-usage')
    # options.add_argument('--window-size=1680,1050')
    # # NOTE: chromedriver(v77)では、Linuxのヘッドレスモードで、下記設定が必要
    # options.add_preference(:download, default_directory: DownloadHelper::PATH.to_s)
  end
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :remote_chrome
    if ENV['SELENIUM_DRIVER_URL'].present?
      Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
      Capybara.server_port = 3000
    end
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end

  config.include LoginMacros
  config.include MailerMacros

  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
end
