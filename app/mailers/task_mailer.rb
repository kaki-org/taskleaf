# frozen_string_literal: true

class TaskMailer < ApplicationMailer
  default from: 'taskleaf@example.com'

  def creation_email(task)
    @task = task
    mail(
      subject: I18n.t('task_created_subject'),
      to: 'user@example.com'
    )
  end
end
