module Renalware
  module Patients
    module Ingestion
      module MessageMappers
        # Given an HL7 message that instructs us to update a patient (eg ADT^A31) or add a new one
        # (ADT^A28) we parse the patient level information from the HL7 message and update or create
        # the patient.
        class Patient < MessageMapper
          delegate :patient_identification, to: :message
          delegate :address, :religion, to: :patient_identification

          def initialize(message, patient = nil)
            @patient = patient || ::Renalware::Patient.new

            super(message)
          end

          attr_reader :patient

          def fetch
            map_attributes
            patient
          end

          private

          # rubocop:disable Metrics/AbcSize
          def map_attributes
            # Don't overwrite existing patient data if the new data is blank?
            patient.attributes = {
              given_name: patient_identification.given_name,
              family_name: patient_identification.family_name,
              suffix: patient_identification.suffix,
              title: patient_identification.title,
              born_on: Time.zone.parse(patient_identification.dob)&.to_date,
              sex: patient_identification.sex,
              ethnicity: find_ethnicity,
              marital_status: patient_identification.marital_status,
              religion: find_religion,
              practice: find_practice(message.practice_code) || patient.practice,
              primary_care_physician: find_primary_care_physician(message.gp_code),
              email: patient_identification.email,
              telephone1: patient_identification.telephone[0],
              telephone2: patient_identification.telephone[1],
              **patient_identification.identifiers
            }.compact_blank

            patient.died_on = parse_death_date(patient_identification.death_date)

            patient.build_current_address if patient.current_address.blank?
            patient.current_address.attributes = {
              street_1: address[0],
              street_2: address[1],
              street_3: nil,
              town: address[2],
              county: address[3],
              postcode: address[4]
            }
          end
          # rubocop:enable Metrics/AbcSize

          # If for some reason we cannot find the new practice (perhaps we have not imported it yet)
          # then be sure to leave the patient's current practice unchanged.
          def find_practice(code)
            Patients::Practice.find_by(code: code) || patient.practice
          end

          # If for some reason we cannot find the new gp (perhaps we have not imported them yet)
          # then be sure to leave the patient's current gp unchanged.
          def find_primary_care_physician(code)
            Patients::PrimaryCarePhysician.find_by(code: code) || patient.primary_care_physician
          end

          def find_ethnicity
            Patients::Ethnicity.find_by(rr18_code: patient_identification.ethnic_group)
          end

          # Support finding religion by code or name
          def find_religion
            return if religion.nil?

            Patients::Religion
              .where(code: religion)
              .or(Patients::Religion.where(name: religion))
              .first
          end

          # We need to bear in mind the situation where the patient may have accidentally been
          # marked as deceased in a previous message, but the current message has '""' or '' for the
          # died_on date, to indicate we should set it nil, un-deceasing them.
          # Note the conversion from '""' to nil is handled in a patient validation callback
          # so here we just check that the date a sensible length to avoid parsing '""' as a date.
          def parse_death_date(death_date_string)
            return nil if death_date_string.blank? || death_date_string == '""'

            Time.zone.parse(death_date_string)&.to_date
          end
        end
      end
    end
  end
end
