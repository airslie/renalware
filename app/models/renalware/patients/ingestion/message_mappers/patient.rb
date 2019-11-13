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
            attrs = {
              local_patient_id: patient_identification.internal_id,
              nhs_number: patient_identification.nhs_number,
              given_name: patient_identification.given_name,
              family_name: patient_identification.family_name,
              suffix: patient_identification.suffix,
              title: patient_identification.title,
              born_on: Time.zone.parse(patient_identification.dob)&.to_date,
              died_on: Time.zone.parse(patient_identification.death_date)&.to_date,
              sex: patient_identification.sex,
              practice: find_practice(message.practice_code) || patient.practice,
              primary_care_physician: find_primary_care_physician(message.gp_code)
            }

            # Don't overwrite existing patient data if the new data is blank?
            attrs.reject! { |_key, value| value.blank? }
            patient.attributes = attrs

            # patient.given_name = patient_identification.given_name
            # patient.family_name = patient_identification.family_name
            # patient.suffix = patient_identification.suffix
            # patient.title = patient_identification.title
            # patient.attributes = {
            #   local_patient_id: patient_identification.internal_id,
            #   nhs_number: patient_identification.nhs_number,
            #   given_name: patient_identification.given_name,
            #   family_name: patient_identification.family_name,
            #   suffix: patient_identification.suffix,
            #   title: patient_identification.title,
            #   born_on: Time.zone.parse(patient_identification.dob)&.to_date,
            #   died_on: Time.zone.parse(patient_identification.death_date)&.to_date,
            #   sex: patient_identification.sex,
            #   practice: find_practice(message.practice_code) || patient.practice,
            #   primary_care_physician: find_primary_care_physician(message.gp_code)
            # }
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
        end
      end
    end
  end
end
