# frozen_string_literal: true

module Api
  module V1
    class TasksController < ApplicationController
      # CSRF 検証より先に認証を確認し、未ログインの更新系にも 401 を返す
      prepend_before_action :login_required
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

      def show
        render json: current_user.tasks.find(params.expect(:id))
      end

      def update
        task = current_user.tasks.find(params.expect(:id))
        if task.update(task_params) # attributes: の指定を削除
          render json: task
        else
          render json: { errors: task.errors.full_messages }, status: :bad_request
        end
      end

      def destroy
        task = current_user.tasks.find(params.expect(:id))
        task.destroy!
        render json: task
      end

      private

      def task_params
        params.expect(task: %i[name description image])
      end

      def login_required
        render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
      end

      def record_not_found
        render json: { error: 'Task not found' }, status: :not_found
      end
    end
  end
end
