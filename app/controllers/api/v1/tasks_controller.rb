# frozen_string_literal: true

class Api::V1::TasksController < ApplicationController
  skip_before_action :login_required

  def show
    render json: Task.find(params[:id])
  end

  def update
    task = Task.find(params[:id])
    render json: task if task.update(attributes: task_params)
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :image)
  end
end
