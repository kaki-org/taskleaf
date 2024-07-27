# frozen_string_literal: true

module Api
  module V1
    class TasksController < ApplicationController
      skip_before_action :login_required
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

      def show
        render json: Task.find(params[:id])
      end

      def update
        task = Task.find(params[:id])
        render json: task if task.update(attributes: task_params)
      end

      def destroy
        task = Task.find(params[:id])
        task.destroy!
        render json: task
      end

      private

      def task_params
        params.require(:task).permit(:name, :description, :image)
      end

      def record_not_found
        render json: { error: 'Task not found' }, status: :not_found
      end
    end
  end
end
