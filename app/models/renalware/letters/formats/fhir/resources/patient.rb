# frozen_string_literal: true

module Renalware
  module Letters
    module Formats::FHIR
      class Resources::Patient
        include Support::Construction
        include Support::Helpers
        delegate :patient, to: :arguments
        delegate :current_address, to: :patient, allow_nil: true

        SEND_HOSPITAL_NUMBER_IDENTIFIERS = false # not sent in GP Connect

        def call
          {
            fullUrl: arguments.patient_urn,
            resource: FHIR::STU3::Patient.new(
              id: arguments.patient_uuid,
              meta: {
                profile: "https://fhir.hl7.org.uk/STU3/StructureDefinition/CareConnect-Patient-1"
              },
              identifier: [
                unverified_nhs_number_identifier,
                *hospital_number_identifiers
              ],
              telecom: telecoms,
              name: name,
              gender: gender,
              birthDate: patient.born_on.to_date.to_s,
              address: address
            )
          }
        end

        private

        def name
          {
            use: "official",
            family: patient.family_name,
            given: patient.given_name,
            prefix: patient.title
          }
        end

        # Use this when a NHS number has been verified by PDS
        def verified_nhs_number_identifier
          {
            extension: {
              url: "https://fhir.hl7.org.uk/STU3/StructureDefinition/Extension-CareConnect-NHSNumberVerificationStatus-1",
              valueCodeableConcept: {
                coding: {
                  system: "https://fhir.hl7.org.uk/STU3/CodeSystem/CareConnect-NHSNumberVerificationStatus-1",
                  code: "01",
                  display: "Number present and verified"
                }
              }
            },
            system: "https://fhir.nhs.uk/Id/nhs-number",
            value: patient.nhs_number
          }
        end

        # Use this when a NHS number has not been been verified by PDS
        def unverified_nhs_number_identifier
          {
            extension: {
              url: "https://fhir.hl7.org.uk/STU3/StructureDefinition/Extension-CareConnect-NHSNumberVerificationStatus-1",
              valueCodeableConcept: {
                coding: {
                  system: "https://fhir.hl7.org.uk/STU3/CodeSystem/CareConnect-NHSNumberVerificationStatus-1",
                  code: "02",
                  display: "Number present but not traced"
                }
              }
            },
            system: "https://fhir.nhs.uk/Id/nhs-number",
            value: patient.nhs_number
          }
        end

        def hospital_number_identifiers
          # Note currently there is no benefit in us sending identifiers other than the NHS number.
          # if this changes, set SEND_HOSPITAL_NUMBER_IDENTIFIERS = true
          return {} unless SEND_HOSPITAL_NUMBER_IDENTIFIERS

          [
            patient.local_patient_id,
            patient.local_patient_id_2,
            patient.local_patient_id_3,
            patient.local_patient_id_4
          ].compact_blank.uniq.map do |hosp_num|
            {
              system: "https://fhir.nhs.uk/Id/local-patient-identifier",
              value: hosp_num
            }
          end
        end

        # See https://fhir.hl7.org.uk/STU3/ValueSet/CareConnect-AdministrativeGender-1
        def gender
          {
            "M" => "male",
            "F" => "female",
            "O" => "other"
          }.fetch(patient.sex, "unknown")
        end

        def telecoms
          [telephone, email_address].compact
        end

        def telephone
          return if patient.telephone1.blank?

          {
            system: "phone",
            value: patient.telephone1,
            use: "home"
          }
        end

        def email_address
          return if patient.email.blank?

          {
            system: "email",
            value: patient.email
          }
        end

        def address
          return [] if current_address.blank?

          [
            {
              # line: [
              #   current_address.street_1,
              #   current_address.street_2,
              #   current_address.street_3,
              #   current_address.town,
              #   current_address.county
              # ].compact_blank,
              postalCode: current_address.postcode
            }
          ]
        end
      end
    end
  end
end
