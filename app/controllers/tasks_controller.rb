# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  ANNIVERSARY_DATE = Date.new(2020, 3, 13)

  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page])
    @special_time = special_time?
    respond_to do |format|
      format.html
      format.csv { send_data @tasks.generate_csv, filename: "tasks-#{Time.zone.now.strftime('%Y%m%d%S')}.csv" }
    end
  end

  def import
    errors = current_user.tasks.import(params[:file])
    if errors.empty?
      redirect_to tasks_url, notice: I18n.t('task_created')
    else
      redirect_to tasks_url, alert: "インポートに失敗しました: #{errors.join(' / ')}"
    end
  end

  def show; end

  def new
    @task = Task.new
  end

  def edit; end

  def create
    # @task = Task.new(task_params.merge(user_id: current_user.id))
    @task = current_user.tasks.new(task_params)

    if @task.save
      TaskMailer.creation_email(@task).deliver_now
      SampleJob.perform_later
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
    else
      render :edit, task: @task.errors, status: :unprocessable_content
    end
  end

  def confirm_destroy
    @task = current_user.tasks.find(params.require(:task_id))
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました" }
      format.turbo_stream { flash.now[:notice] = "タスク「#{@task.name}」を削除しました" }
    end
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.expect(task: %i[name description image])
  end

  def special_time?
    today = Date.current
    today.month == ANNIVERSARY_DATE.month && today.day == ANNIVERSARY_DATE.day
  end
end
