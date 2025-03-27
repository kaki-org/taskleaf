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
        if task.update(task_params) # attributes: の指定を削除
          render json: task
        else
          render json: { errors: task.errors.full_messages }, status: :bad_request
        end
      end

      def destroy
        task = Task.find(params[:id])
        task.destroy!
        render json: task
      end

      private

      def task_params
        params.expect(task: %i[name description image])
      end

      def record_not_found
        render json: { error: 'Task not found' }, status: :not_found
      end
    end
  end
end
