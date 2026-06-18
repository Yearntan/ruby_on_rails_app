require 'rails_helper'

RSpec.describe ApplicationJob, type: :job do
  let(:job) { described_class.new }

  describe 'error handling' do
    context 'when ActiveRecord::Deadlocked is raised' do
      it 'retries the job' do
        allow(job).to receive(:perform).and_raise(ActiveRecord::Deadlocked)
        expect(job).to receive(:retry_job).with(wait: 3.seconds)  # Adjust based on your specific retry settings
        perform_enqueued_jobs { job.perform_now }
      end
    end

    context 'when ActiveJob::DeserializationError is raised' do
      it 'discards the job' do
        allow(job).to receive(:perform).and_raise(ActiveJob::DeserializationError)
        expect(job).not_to receive(:retry_job)
        perform_enqueued_jobs { job.perform_now }
      end
    end
  end
end
