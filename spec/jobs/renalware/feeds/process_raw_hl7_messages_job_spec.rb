module Renalware
  module Feeds
    describe ProcessRawHL7MessagesJob do
      let(:instance) { described_class.new }
      let(:message_processor) { instance_double(MessageProcessor, call: nil) }

      let(:raw_hl7_message_1) { create(:raw_hl7_message, body: "FIR\rST\r_M") }
      let(:raw_hl7_message_2) { create(:raw_hl7_message, body: "SECOND_M") }

      before do
        raw_hl7_message_1 && raw_hl7_message_2

        allow(ProcessRawHL7MessageJob).to receive(:perform_now)
      end

      describe "#perform" do
        it "calls out to the message processor" do
          described_class.perform_now

          expect(ProcessRawHL7MessageJob)
            .to have_received(:perform_now)
            .with(message: "FIR\nST\n_M")

          expect(ProcessRawHL7MessageJob)
            .to have_received(:perform_now)
            .with(message: "SECOND_M")

          expect(RawHL7Message.count).to eq 0
        end
      end

      context "when processing a message raises an error" do
        it "creates a RawHL7MessageError record and continues processing" do
          create(:raw_hl7_message, body: "DIVIDE_BY_ZERO")

          expect {
            described_class.perform_now
          }.to change(Renalware::Feeds::RawHL7MessageError, :count).by(1)

          expect(ProcessRawHL7MessageJob)
            .to have_received(:perform_now)
            .with(message: "FIR\nST\n_M")

          expect(ProcessRawHL7MessageJob)
            .to have_received(:perform_now)
            .with(message: "SECOND_M")

          expect(RawHL7Message.count).to eq 0
          expect(RawHL7MessageError.count).to eq 1

          expect(RawHL7MessageError.last.body).to eq "DIVIDE_BY_ZERO"
          expect(RawHL7MessageError.last.error_message).to eq "divided by 0"
          expect(RawHL7MessageError.last.error_message_backtrace)
            .to include("process_raw_hl7_messages_job.rb")
        end
      end
    end
  end
end
