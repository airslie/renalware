# frozen_string_literal: true

module Renalware
  module Letters
    module Formats::FHIR
      #
      # FHIR resource representing a Drug + Form combination
      #
      class Resources::Medication
        include Support::Construction
        include Support::Helpers

        def call
          prescription_uuid = SecureRandom.uuid # TODO
          {
            fullUrl: "urn:uuid:#{prescription_uuid}",
            resource: FHIR::STU3::Medication.new(
              id: prescription_uuid,
              meta: {
                profile: "https://fhir.nhs.uk/STU3/StructureDefinition/CareConnect-ITK-Medication-1"
              },
              code: snomed_coding("drug snomed code", "drug name"),
              form: snomed_coding("form snomed code", "form name")
            )
          }
        end

        def prescription
          @prescription = options.delete(:prescription)
        end
      end
    end
  end
end
