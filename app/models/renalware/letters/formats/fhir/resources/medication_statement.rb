module Renalware
  module Letters
    module Formats::FHIR
      #
      # FHIR resource representing a Medications::Prescription
      # https://www.hl7.org/fhir/medicationstatement.html
      #
      class Resources::MedicationStatement
        include Support::Construction
        include Support::Helpers

        def call
          {
            fullUrl: "urn:uuid:#{prescription_uuid}",
            resource: resource
          }
        end

        def resource
          ::FHIR::STU3::MedicationStatement.new(
            id: prescription_uuid,
            meta: {
              profile: "https://fhir.nhs.uk/STU3/StructureDefinition/CareConnect-ITK-MedicationStatement-1"
            },
            extension: {
              url: "https://fhir.hl7.org.uk/STU3/StructureDefinition/Extension-CareConnect-MedicationChangeSummary-1",
              extension: [
                {
                  url: "status",
                  valueCode: "Amended"
                },
                {
                  url: "dateChanged",
                  valueDateTime: "2017-05-01"
                },
                {
                  url: "detailsOfAmendment",
                  valueString: "GP to prescribe 28 x 1000ml bags per month, ongoing." # TODO
                }
              ]
            },
            # context: {
            #   reference: arguments.encounter_urn
            # },
            # status of active|completed|entered-in-error|intended|stopped|on-hold|unknown|not-taken
            status: "active",
            # medicationReference: {
            #   reference: medication_urn
            # },
            subject: {
              reference: arguments.patient_urn
            },
            taken: "unk", # ?? Can't find in DIR docs
            dosage: {
              text: "e.g. 100mls per hour for 10 hours daily, 9am-7pm", # TODO: this is an example
              patientInstruction: "e.g. 1400mls water given as divided flushes (e.g. 10x140mls)
                                  throughout the day e.g. before and after feed and with
                                  medications.", # TODO: this is an example
              route: snomed_coding("e.g. 372454008", "e.g. Gastroenteral") # TODO: example
            }
          )
        end

        def prescription
          @prescription = options.delete(:prescription)
        end

        def medication_urn
          @medication_urn = options.delete(:medication_urn)
        end

        def prescription_uuid
          SecureRandom.uuid # TODO
        end
      end
    end
  end
end
