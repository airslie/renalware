# frozen_string_literal: true

# rubocop:disable RSpec/SpecFilePathFormat

require "opentelemetry/sdk"

RSpec.describe ApplicationJob do
  subject(:job_class) do
    Class.new(described_class) do
      def perform
        raise ArgumentError, "boom"
      end
    end
  end

  describe "error handling" do
    let(:span) { instance_double(OpenTelemetry::Trace::Span, recording?: true) }
    let(:status) { instance_double(OpenTelemetry::Trace::Status) }

    before do
      allow(span).to receive(:record_exception)
      allow(span).to receive(:status=)
      allow(OpenTelemetry::Trace).to receive(:current_span).and_return(span)
      allow(OpenTelemetry::Trace::Status).to receive(:error).with("job failed").and_return(status)
    end

    it "records errors on the current OpenTelemetry span and re-raises" do
      expect { job_class.perform_now }.to raise_error(ArgumentError, "boom")

      expect(span).to have_received(:record_exception).with(instance_of(ArgumentError))
      expect(OpenTelemetry::Trace::Status).to have_received(:error).with("job failed")
      expect(span).to have_received(:status=).with(status)
    end

    it "re-raises without recording when the span is not recording" do
      allow(span).to receive(:recording?).and_return(false)

      expect { job_class.perform_now }.to raise_error(ArgumentError, "boom")

      expect(span).not_to have_received(:record_exception)
      expect(OpenTelemetry::Trace::Status).not_to have_received(:error)
      expect(span).not_to have_received(:status=)
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
