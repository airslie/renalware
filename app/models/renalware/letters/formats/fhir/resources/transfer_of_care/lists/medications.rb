# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR
    module Resources::TransferOfCare
      class Lists::Medications
        include Support::Construction
        include Support::Helpers

        def call
          {
            fullUrl: "urn:uuid:cef7f8d5-78e3-4866-89f1-62470d6fd636",
            resource: FHIR::STU3::List.new(
              id: "cef7f8d5-78e3-4866-89f1-62470d6fd636",
              meta: {
                profile: "https://fhir.nhs.uk/STU3/StructureDefinition/CareConnect-ITK-Medication-List-1"
              },
              identifier: system_identifier("c28e33b7-dd29-4c9d-957c-ab4a834e5e77"),
              status: "current",
              mode: "snapshot",
              code: snomed_coding("1102411000000102", "Active medications")
              # subject: {
              #   reference: "urn:uuid:4e17be8f-8694-47e3-8740-ccf306f6cf02"
              # },
              # encounter: {
              #   reference: arguments.encounter_urn
              # },
              # source: {
              #   reference: "urn:uuid:2c064afa-dbd6-44b8-86e6-a3e7fbdbcb48"
              # },
              # entry: {
              #   item: {
              #     reference: "urn:uuid:9ab72b73-c3e2-434a-a7df-234134215a7e"
              #   }
              # }
            )
          }
        end
      end
    end
  end
end
