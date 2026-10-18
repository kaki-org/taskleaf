# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  ANNIVERSARY_DATE = Date.new(2020, 3, 13)

  def index
    @tasks = current_user.tasks.ransack(params[:q]).result(distinct: true).page(params[:page])
    respond_to do |format|
      format.html { render inertia: 'Tasks/Index', props: index_props }
      format.csv { send_data @tasks.generate_csv, filename: csv_filename }
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

  def show
    render inertia: 'Tasks/Show', props: { task: task_detail_props(@task) }
  end

  def new
    render inertia: 'Tasks/New'
  end

  def edit
    render inertia: 'Tasks/Edit', props: { task: @task.slice(:id, :name, :description) }
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      TaskMailer.creation_email(@task).deliver_now
      SampleJob.perform_later
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    else
      redirect_to new_task_url, inertia: { errors: @task.errors.to_hash(true) }
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
    else
      redirect_to edit_task_url(@task), inertia: { errors: @task.errors.to_hash(true) }
    end
  end

  def confirm_destroy
    task = current_user.tasks.find(params.require(:task_id))
    render inertia: 'Tasks/ConfirmDestroy', props: { task: task_detail_props(task) }
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました"
  end

  private

  def set_task
    @task = current_user.tasks.find(params.expect(:id))
  end

  def task_params
    params.expect(task: %i[name description image])
  end

  def csv_filename
    "tasks-#{Time.zone.now.strftime('%Y%m%d%S')}.csv"
  end

  def index_props
    {
      tasks: @tasks.map { |task| task.slice(:id, :name).merge(created_at: task.created_at.to_s) },
      pagination: { current_page: @tasks.current_page, total_pages: @tasks.total_pages },
      entries_info: Nokogiri::HTML5.fragment(helpers.page_entries_info(@tasks)).text,
      query: params.fetch(:q, {}).permit(:name_cont, :created_at_gteq, :s),
      special_time: special_time?
    }
  end

  def task_detail_props(task)
    {
      id: task.id,
      name: task.name,
      # ERB と同じく HTML をエスケープしてから改行とリンクを付ける
      description_html: helpers.auto_link(helpers.simple_format(ERB::Util.h(task.description), {}, sanitize: false, wrapper_tag: 'div')),
      image_url: task.image.attached? ? url_for(task.image) : nil,
      created_at: task.created_at.to_s,
      updated_at: task.updated_at.to_s
    }
  end

  def special_time?
    today = Date.current
    today.month == ANNIVERSARY_DATE.month && today.day == ANNIVERSARY_DATE.day
  end
end
