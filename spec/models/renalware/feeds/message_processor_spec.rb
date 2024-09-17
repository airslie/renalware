# frozen_string_literal: true

# rubocop:disable RSpec/AnyInstance
module Renalware::Feeds
  describe MessageProcessor do
    include HL7Helpers

    def hl7_data
      OpenStruct.new(
        hospital_number: "A123",
        nhs_number: "9999999999",
        family_name: "new_family_name",
        given_name: "new_given_name",
        born_on: Time.zone.parse("2002-02-01").to_date,
        died_at: Time.zone.parse("2003-03-02").to_date,
        gp_code: "G123",
        practice_code: "P456"
      )
    end

    describe "#call" do
      context "when a message with the same content already exists in feed_messages" do
        it "does not raise an error or notify the exception" do
          message_processor = described_class.new
          allow(Renalware::Engine.exception_notifier).to receive(:notify)
          allow_any_instance_of(PersistMessage)
            .to receive(:call)
            .and_raise(DuplicateMessageError.new)

          expect { message_processor.call("raw_hl7") }.not_to raise_error
          expect(Renalware::Engine.exception_notifier).not_to have_received(:notify)
        end
      end

      context "when persisting a message raise some other kind of error" do
        it "notifies the exception and re-raises it" do
          message_processor = described_class.new
          allow(Renalware::Engine.exception_notifier).to receive(:notify)
          allow_any_instance_of(PersistMessage)
            .to receive(:call)
            .and_raise(ArgumentError.new)

          expect { message_processor.call("raw_hl7") }.to raise_error(ArgumentError)
          expect(Renalware::Engine.exception_notifier).to have_received(:notify)
        end
      end

      context "when successfully saved" do
        it "sets processed to true" do
          hl7_message = parse_hl7_file("ORU_R01", hl7_data)

          expect {
            described_class.new.call(hl7_message)
          }.to change(Renalware::Feeds::Message, :count).by(1)

          expect(Renalware::Feeds::Message.last).to have_attributes(
            processed: true
          )
        end
      end
    end
  end
end
# rubocop:enable RSpec/AnyInstance
