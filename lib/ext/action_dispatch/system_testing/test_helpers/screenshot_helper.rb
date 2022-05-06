require 'action_dispatch/system_testing/test_helpers/screenshot_helper'

module ActionDispatch::SystemTesting::TestHelpers::ScreenshotHelper
  private

  def supports_screenshot?
    return false unless ActiveRecord::Type::Boolean.new.cast(ENV['SCREENSHOT_ON_FAILURE'])

    Capybara.current_driver != :rack_test
  end
end
