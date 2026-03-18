# frozen_string_literal: true

require "opentelemetry/sdk"

RSpec.describe OpenTelemetryErrorSubscriber do
  subject(:subscriber) { described_class.new }

  let(:span) { instance_double(OpenTelemetry::Trace::Span, recording?: true) }
  let(:status) { instance_double(OpenTelemetry::Trace::Status) }
  let(:error) { ArgumentError.new("boom") }

  before do
    allow(span).to receive(:record_exception)
    allow(span).to receive(:status=)
    allow(span).to receive(:set_attribute)
    allow(OpenTelemetry::Trace).to receive(:current_span).and_return(span)
    allow(OpenTelemetry::Trace::Status).to receive(:error).with("ArgumentError").and_return(status)
  end

  it "records the exception and scalar context on the current span", :aggregate_failures do
    subscriber.report(
      error,
      handled: false,
      severity: :error,
      source: "application.active_job",
      context: {
        job: "TestJob",
        attempt: 1,
        metadata: { ignored: true }
      }
    )

    expect(span).to have_received(:record_exception).with(error)
    expect(span).to have_received(:status=).with(status)
    expect(span).to have_received(:set_attribute).with("error.source", "application.active_job")
    expect(span).to have_received(:set_attribute).with("error.handled", false)
    expect(span).to have_received(:set_attribute).with("error.severity", "error")
    expect(span).to have_received(:set_attribute).with("error.context.job", "TestJob")
    expect(span).to have_received(:set_attribute).with("error.context.attempt", 1)
    expect(span).not_to have_received(:set_attribute).with("error.context.metadata", anything)
  end

  it "does nothing when the current span is not recording" do
    allow(span).to receive(:recording?).and_return(false)

    subscriber.report(error, handled: false, severity: :error, source: "application", context: {})

    expect(span).not_to have_received(:record_exception)
    expect(span).not_to have_received(:status=)
    expect(span).not_to have_received(:set_attribute)
  end
end
