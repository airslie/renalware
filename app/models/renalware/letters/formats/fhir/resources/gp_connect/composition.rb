module Renalware::Letters
  module Formats::FHIR
    module Resources
      module GPConnect
        # FHIR resource representing a letter
        class Composition
          include Support::Construction
          include Support::Helpers

          PROFILE_URL = "https://fhir.hl7.org.uk/STU3/StructureDefinition/CareConnect-Composition-1".freeze
          CARE_SETTING_TYPE_EXTENSION_URL =
            "https://fhir.hl7.org.uk/STU3/StructureDefinition/Extension-CareConnect-CareSettingType-1"
              .freeze

          def call
            {
              fullUrl: arguments.letter_urn,
              resource: ::FHIR::STU3::Composition.new(
                id: arguments.letter_uuid,
                identifier: system_identifier(SecureRandom.uuid), # TODO
                meta: {
                  profile: PROFILE_URL
                },
                text: {
                  status: "generated",
                  div: "<div xmlns=\"http://www.w3.org/1999/xhtml\">#{arguments.document_title}</div>"
                },
                status: "final",
                type: {
                  coding: [
                    snomed_coding_content(
                      arguments.document_type_snomed_code,
                      arguments.document_type_snomed_title
                    )
                  ]
                },
                subject: {
                  reference: arguments.patient_urn
                },
                date: arguments.request.document.approved_at.to_datetime.utc.iso8601,
                author: {
                  reference: arguments.author_urn
                },
                custodian: {
                  reference: arguments.organisation_urn
                },
                extension: care_setting_type_extension,
                title: arguments.composition_title,
                confidentiality: arguments.confidentiality,
                section: {
                  entry: [
                    { title: arguments.composition_title },
                    { reference: arguments.organisation_urn },
                    { reference: arguments.author_urn },
                    { reference: arguments.patient_urn },
                    { reference: arguments.binary_urn }
                  ]
                }
              )
            }
          end

          private

          def care_setting_type_extension
            {
              url: CARE_SETTING_TYPE_EXTENSION_URL,
              valueCodeableConcept: snomed_coding(
                arguments.request.sender.care_setting_snomed_code,
                arguments.request.sender.care_setting_description
              )
            }
          end
        end
      end
    end
  end
end
