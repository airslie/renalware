# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR
    module Resources::TransferOfCare
      class Lists::AllergiesAndAdverseReactions
        include Support::Construction
        include Support::Helpers

        def call
          {
            fullUrl: "urn:uuid:ecbeffa7-1adf-4301-a94f-1e297e4fed93",
            resource: ::FHIR::STU3::List.new(
              id: "ecbeffa7-1adf-4301-a94f-1e297e4fed93", # TODO
              meta: {
                profile: "https://fhir.nhs.uk/STU3/StructureDefinition/CareConnect-ITK-Allergy-List-1"
              },
              identifier: system_identifier("bbde54bb-adfb-452e-a829-c50a42709080"),
              status: "current",
              mode: "snapshot",
              code: snomed_coding("886921000000105", "Allergies and adverse reactions"),
              subject: {
                reference: arguments.patient_urn
              }
              # encounter: {
              #   reference: arguments.encounter_urn
              # },
              # source: {
              #   # Practitioner who recorded the allergy - leave empty?
              #   # reference: "urn:uuid:2c064afa-dbd6-44b8-86e6-a3e7fbdbcb48"
              # },
              # entry: [
              #   # an entry for each AllergyIntolerance
              #   {
              #     item: {
              #       reference: "urn:uuid:6f8f2868-231d-4066-928c-3f7e0a116112" # TODO
              #     }
              #   }
              # ]
            )
          }
        end
      end
    end
  end
end
