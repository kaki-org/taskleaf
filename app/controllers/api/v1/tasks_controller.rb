# frozen_string_literal: true

class ApiV1TasksController < ApplicationController
  skip_before_action :login_required
  def show
    render json: Task.find(params[:id])
  end
end
