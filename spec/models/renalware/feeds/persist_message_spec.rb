# frozen_string_literal: true

require "rails_helper"

module Renalware::Feeds
  describe PersistMessage do
    subject(:service) { described_class.new }

    describe "#call" do
      let(:hl7_message) {
        instance_double(
          HL7Message,
          type: "::message type code::",
          header_id: "::header id::",
          to_hl7: "::message body::",
          patient_identification: double(
            internal_id: "123",
            hospital_identifiers: {},
            nhs_number: "1"
          )
        )
      }

      it "persists the payload" do
        expect { service.call(hl7_message) }.to change(Message, :count).by(1)
      end

      it "generates an MD5 hash of the payload which should be unique and therefore " \
         "prevent duplicate" do
        service.call(hl7_message)

        expect(Message.first.body_hash).to eq(Digest::MD5.hexdigest("::message body::"))
      end

      it "causes a database unique constraint violation if the same message body is saved twice" do
        service.call(hl7_message)

        expect {
          service.call(hl7_message)
        }.to raise_error(
          Renalware::Feeds::DuplicateMessageError,
          "header_id=::header id::, body_hash=#{Digest::MD5.hexdigest('::message body::')}"
        )
      end
    end
  end
end
