module Renalware
  module Feeds
    class PersistMessage
      # hl7_message is an HL7Message (a decorator around ::HL7::Message)
      # If the same message is persisted twice we'll get an ActiveRecord::RecordNotUnique error
      # but that's fine as we don't want to process the same HL7 message twice.
      def call(hl7_message)
        body_hash = Digest::MD5.hexdigest(hl7_message.to_hl7)

        # map eg 'HOSP2' => 'H1111' to local_patient_id_2: 'H1111'
        hl7_message.patient_identification&.hospital_identifiers

        Message.create!(
          sent_at: hl7_message.time,
          message_type: hl7_message.message_type,
          event_type: hl7_message.event_type,
          header_id: hl7_message.header_id,
          body: hl7_message.to_s,
          body_hash: body_hash,
          orc_order_status: hl7_message.orc_order_status,
          orc_filler_order_number: hl7_message.orc_filler_order_number,
          dob: hl7_message.patient_dob,
          nhs_number: hl7_message.patient_identification&.nhs_number,
          patient_identifiers: hl7_message.patient_identification&.hospital_identifiers,
          **mapped_hash_of_local_patient_ids(hl7_message.patient_identification)
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

      def identifier_map
        Renalware.config.patient_hospital_identifiers
      end

      # Given an HL7Message.patient_identification object that looks like this:
      # {
      #   "HOSP1" => "1111",
      #   "HOSP2" => "2222",
      #   "HOSP3" => "3333",
      #   "HOSP4" => "4444",
      #   "HOSP5" => "5555"
      # }
      # Map each assigning authority (eg HOSP1 but could be eg KCH), if known, to one
      # of the patient.local_patient_id* columns and store the value, so we return something
      # like this:
      # {
      #   local_patient_id_2: "1111",
      #   local_patient_id_3: "2222",
      #   local_patient_id: "3333",
      #   local_patient_id_5: "4444",
      #   local_patient_id_4: "5555"
      # }
      def mapped_hash_of_local_patient_ids(patient_identification)
        hospital_identifiers = patient_identification.hospital_identifiers || {}

        hospital_identifiers.each_with_object({}) do |(hosp, number), hash|
          local_patient_id_column_name = Renalware.config.patient_hospital_identifiers[hosp.to_sym]
          if local_patient_id_column_name
            hash[local_patient_id_column_name.to_sym] = number
          end
        end
      end
    end
  end
end
