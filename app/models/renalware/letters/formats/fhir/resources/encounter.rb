module Renalware
  module Letters
    module Formats::FHIR
      #
      # FHIR resource representing a Clinics::ClinicVisit associated with a Letters::Letter
      #
      class Resources::Encounter
        include Support::Construction
        include Support::Helpers

        ENCOUNTER_IDENTIFIER = "13c73015-d8fa-4844-8d68-4f856883eca8".freeze

        def call
          {
            fullUrl: arguments.encounter_urn,
            resource: ::FHIR::STU3::Encounter.new(
              id: arguments.encounter_uuid,
              meta: {
                profile: "https://fhir.nhs.uk/STU3/StructureDefinition/CareConnect-ITK-Encounter-1"
              },
              # TODO: to discuss - do we (want) to capture visit outcome?
              # 1 Discharged from Consultant's care (last attendance)
              # 2 Another Appointment given
              # 3 Appointment to be made at a later date
              # extension: {
              #   url: "https://fhir.hl7.org.uk/STU3/StructureDefinition/Extension-CareConnect-OutcomeOfAttendance-1",
              #   valueCodeableConcept: {
              #     coding: {
              #       system: "https://fhir.hl7.org.uk/STU3/CodeSystem/CareConnect-OutcomeOfAttendance-1",
              #       code: "3",
              #       display: "Appointment to be made at a later date"
              #     }
              #   }
              # },
              identifier: system_identifier(ENCOUNTER_IDENTIFIER), # TODO
              status: "finished",
              period: {
                start: arguments.clinic_visit&.datetime&.to_s,
                end: arguments.clinic_visit&.datetime&.to_s
              },
              # https://terminology.hl7.org/2.1.0/ValueSet-v3-ActAmbulatoryEncounterCode.html
              # The term ambulatory usually implies that the patient has come to the location and is
              # not assigned to a bed. Sometimes referred to as an outpatient encounter.
              class: {
                system: "http://hl7.org/fhir/v3/ActCode",
                code: "AMB",
                display: "ambulatory"
              },
              # Specific type of encounter
              # Not sure we capture this eg 'First attendance face to face'
              # See the options here
              # https://www.datadictionary.nhs.uk/data_sets/cds_v6-3/cds_v6-3_type_020_-_outpatient_cds.html
              # type: {
              #   coding: {
              #     system: "https://www.datadictionary.nhs.uk",
              #     code: "1",
              #     display: "First attendance face to face"
              #   }
              # },
              # Reference to the patient as the subject of the Encounter
              subject: {
                reference: arguments.patient_urn
              },
              # Reference to the participant(s) present during the encounter.
              # This is the practitioner no thr patient.
              # TODO: I think this is the letter author? TBD
              participant: [
                {
                  type: {
                    coding: {
                      system: "http://hl7.org/fhir/v3/ParticipationType",
                      code: "ATND",
                      display: "attender"
                    }
                  },
                  individual: {
                    reference: arguments.author_urn
                  }
                }
              ]
            )
          }
        end
      end
    end
  end
end
