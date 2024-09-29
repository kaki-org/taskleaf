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

RSpec.describe SampleJob do
  describe '#perform_later' do
    it 'queues the job' do
      expect do
        described_class.perform_later
      end.to have_enqueued_job(described_class)
    end

    describe '#perform_later' do
      it 'executes perform' do
        job_instance = described_class.new
        allow(described_class).to receive(:new).and_return(job_instance)
        expect(job_instance).to receive(:perform)
        perform_enqueued_jobs { described_class.perform_later }
      end
    end
  end

  describe '#perform' do
    it 'logs a message' do
      expect(Rails.logger).to receive(:info).with('サンプルジョブを実行しました')
      described_class.new.perform
    end
  end
end
