# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    module Ingestion
      module MessageMappers
        # Given an HL7 message that instructs us to update a patient (eg ADT^A31) or add a new one
        # (ADT^A28) we parse the patient level information from the HL7 message and update or create
        # the patient.
        class Patient < MessageMapper
          delegate :patient_identification, to: :message
          delegate :address, to: :patient_identification

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

          # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          def map_attributes
            patient.attributes = {
              local_patient_id: patient_identification.internal_id,
              nhs_number: patient_identification.external_id,
              given_name: patient_identification.given_name,
              family_name: patient_identification.family_name,
              suffix: patient_identification.suffix,
              title: patient_identification.title,
              born_on: Time.zone.parse(patient_identification.dob)&.to_date,
              died_on: Time.zone.parse(patient_identification.death_date),
              sex: patient_identification.sex,
              practice: find_practice(message.practice_code),
              primary_care_physician: find_primary_care_physician(message.gp_code)
            }
            patient.build_current_address if patient.current_address.blank?
            patient.current_address.attributes = {
              street_1: address[0],
              street_2: address[1],
              street_3: nil,
              town: address[2],
              county: address[3],
              postcode: address.last
            }
          end
          # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

          def find_practice(code)
            Patients::Practice.find_by(code: code)
          end

          def find_primary_care_physician(code)
            Patients::PrimaryCarePhysician.find_by(code: code)
          end
        end
      end
    end
  end
end
