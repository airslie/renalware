module Renalware
  module Letters
    module Formats
      module FHIR
        module Resources
          class AllergyIntolerance
            include Support::Construction
            include Support::Helpers

            def call
              {
                fullUrl: "urn:uuid:6f8f2868-231d-4066-928c-3f7e0a116112",
                resource: ::FHIR::STU3::AllergyIntolerance.new(
                  id: "6f8f2868-231d-4066-928c-3f7e0a116112",
                  meta: {
                    profile: "https://fhir.nhs.uk/STU3/StructureDefinition/CareConnect-ITK-AllergyIntolerance-1"
                  },
                  identifier: system_identifier("432351ad-3ecf-4444-a718-99e86e365d2d"),
                  # NB: clinicalStatus and verificationStatus are defined as CodeableConcepts in
                  # FHIR spec but in the NHS example for ToC its just a string which does not
                  # validate
                  # Need to investigate
                  # clinicalStatus: "active",
                  # verificationStatus: "confirmed",
                  code: snomed_coding("716186003", "No known allergy"), # TODO!!
                  patient: {
                    reference: arguments.patient_urn
                  }
                )
              }
            end
          end
        end
      end
    end
  end
end
