# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login_required # FIXME: Controller Specをテストする間は一時的にコメントアウト
  include Secured

  private

end
