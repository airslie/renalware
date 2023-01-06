# frozen_string_literal: true

module Renalware
  module Feeds
    class PersistMessage
      # hl7_message is an HL7Message (a decorator around ::HL7::Message)
      # If the same message is persisted twice we'll get an ActiveRecord::RecordNotUnique error
      # but that's fine as we don't want to process the same HL7 message twice.
      # rubocop:disable Metrics/MethodLength
      def call(hl7_message)
        body_hash = Digest::MD5.hexdigest(hl7_message.to_hl7)

        Message.create!(
          event_code: hl7_message.type,
          header_id: hl7_message.header_id,
          body: hl7_message.to_s,
          body_hash: body_hash,
          patient_identifier: hl7_message.patient_identification&.nhs_number,
          patient_identifiers: hl7_message.patient_identification&.hospital_identifiers
        )
      rescue ActiveRecord::RecordNotUnique
        # If a duplicate messages comes in (we have calculated the body_hash for the message and it
        # turns out that body_hash is not unique in the database, meaning the message is already
        # stored) then raise a custom error so it can be handled upstream - ie we can choose to
        # ignore it.
        raise(
          DuplicateMessageError,
          "header_id=#{hl7_message.header_id}, body_hash=#{body_hash}"
        )
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
