# frozen_string_literal: true

module Renalware
  module Feeds
    describe ProcessRawHL7MessageJob do
      let(:instance) { described_class.new }
      let(:message_processor) { instance_double(MessageProcessor, call: nil) }

      before do
        allow(Feeds).to receive(:message_processor).and_return(message_processor)
      end

      describe "#perform" do
        it "calls out to the message processor" do
          described_class.perform_now(message: "MESSAGE")
          expect(message_processor).to have_received(:call).with("MESSAGE")
        end
      end
    end
  end
end
