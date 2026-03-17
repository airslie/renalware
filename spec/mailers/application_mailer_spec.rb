# frozen_string_literal: true

require "opentelemetry/sdk"

RSpec.describe ApplicationMailer do
  subject(:mailer_class) do
    stub_const("TestMailer", Class.new(described_class) do
      def test_me
        mail(
          to: ["to1@example.com", "to2@example.com"],
          subject: "test subject",
          from: "from@example.com"
        ) { |format| format.text { raise ArgumentError, "boom" } }
      end
    end)
  end

  describe "error handling" do
    let(:span) { instance_double(OpenTelemetry::Trace::Span, recording?: true) }
    let(:status) { instance_double(OpenTelemetry::Trace::Status) }

    before do
      allow(span).to receive(:record_exception)
      allow(span).to receive(:status=)
      allow(span).to receive(:set_attribute)
      allow(OpenTelemetry::Trace).to receive(:current_span).and_return(span)
      allow(OpenTelemetry::Trace::Status)
        .to receive(:error).with("mailer failed").and_return(status)
    end

    it "records exception and mail metadata on the current OpenTelemetry span",
       :aggregate_failures do
      expect { mailer_class.test_me.deliver_now }.to raise_error(ArgumentError, "boom")

      expect(span).to have_received(:record_exception).with(instance_of(ArgumentError))
      expect(span).to have_received(:status=).with(status)
      expect(OpenTelemetry::Trace::Status).to have_received(:error).with("mailer failed")
      expect(span)
        .to have_received(:set_attribute).with("mail.to", "to1@example.com, to2@example.com")
      expect(span).to have_received(:set_attribute).with("mail.from", "from@example.com")
      expect(span).to have_received(:set_attribute).with("mail.mailer", "TestMailer")
      expect(span).to have_received(:set_attribute).with("mail.action", "test_me")
    end

    it "re-raises without recording when the span is not recording" do
      allow(span).to receive(:recording?).and_return(false)

      expect { mailer_class.test_me.deliver_now }.to raise_error(ArgumentError, "boom")

      expect(span).not_to have_received(:record_exception)
      expect(span).not_to have_received(:status=)
      expect(span).not_to have_received(:set_attribute)
      expect(OpenTelemetry::Trace::Status).not_to have_received(:error)
    end
  end
end
