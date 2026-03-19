# frozen_string_literal: true

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
    before do
      allow(Rails.error).to receive(:report)
    end

    it "reports the error through Rails.error and re-raises",
       :aggregate_failures do
      expect { mailer_class.test_me.deliver_now }.to raise_error(ArgumentError, "boom")

      expect(Rails.error).to have_received(:report).with(
        instance_of(ArgumentError),
        handled: false,
        source: "application.action_mailer",
        context: {
          mailer: "TestMailer",
          action: "test_me"
        }
      )
    end
  end
end
