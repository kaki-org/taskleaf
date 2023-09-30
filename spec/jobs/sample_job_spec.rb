# frozen_string_literal: true

require 'rails_helper'

# RSpec.describe SampleJob, type: :job do
#   describe '#perform' do
#     before { described_class.perform_later }

#     it 'logs a message' do
#       expect(logger).to receive(:info).with('サンプルジョブを実行しました')
#       # SampleJob.perform_now
#     end
#   end
# end

RSpec.describe SampleJob, type: :job do
  describe '#perform_later' do
    it 'queues the job' do
      expect do
        SampleJob.perform_later
      end.to have_enqueued_job(SampleJob)
    end

    describe '#perform_later' do
      it 'executes perform' do
        expect_any_instance_of(SampleJob).to receive(:perform)
        perform_enqueued_jobs { SampleJob.perform_later }
      end
    end
  end

  describe '#perform' do
    it 'logs a message' do
      expect(Rails.logger).to receive(:info).with('サンプルジョブを実行しました')
      SampleJob.new.perform
    end
  end
end
