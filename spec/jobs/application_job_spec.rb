# frozen_string_literal: true

# rubocop:disable RSpec/SpecFilePathFormat

RSpec.describe ApplicationJob do
  subject(:job_class) do
    stub_const("TestJob", Class.new(described_class) do
      def perform
        raise ArgumentError, "boom"
      end
    end)
  end

  describe "error handling" do
    before do
      allow(Rails.error).to receive(:report)
    end

    it "reports errors through Rails.error and re-raises" do
      expect { job_class.perform_now }.to raise_error(ArgumentError, "boom")

      expect(Rails.error).to have_received(:report).with(
        instance_of(ArgumentError),
        handled: false,
        source: "application.active_job",
        context: include(
          job: "TestJob",
          queue_name: "default",
          job_id: kind_of(String)
        )
      )
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
