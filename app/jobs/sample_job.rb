# frozen_string_literal: true

class SampleJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    # Do something later
    logger.info 'サンプルジョブを実行しました'
  end
end
