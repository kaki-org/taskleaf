# frozen_string_literal: true

class Api < ApplicationController
  class V1
    class TasksController
      skip_before_action :login_required
      def show
        render json: Task.find(params[:id])
      end
    end
  end
end
