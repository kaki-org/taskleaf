# frozen_string_literal: true

module Api
  module V1

  end
end
class Api::V1::TasksController < ApplicationController
  skip_before_action :login_required

  def show
    render json: Task.find(params[:id])
  end
end
