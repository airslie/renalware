module Renalware
  module Letters
    module Formats::FHIR
      module Resources::TransferOfCare
        # FHIR resource representing a letter
        class Composition
          include Support::Construction
          include Support::Helpers

          # rubocop:disable Metrics/MethodLength
          def call
            {
              fullUrl: arguments.letter_urn,
              resource: ::FHIR::STU3::Composition.new(
                id: arguments.letter_uuid,
                title: letter.description,
                date: letter.updated_at.to_datetime.to_s,
                author: {
                  reference: arguments.author_urn
                },
                meta: {
                  profile: "https://fhir.nhs.uk/STU3/StructureDefinition/CareConnect-ITK-OPL-Composition-1"
                },
                status: "final",
                type: snomed_coding("823681000000100", "Outpatient letter"),
                identifier: system_identifier(SecureRandom.uuid), # TODO
                subject: {
                  reference: arguments.patient_urn
                },
                # Identifies the organization responsible for
                # ongoing maintenance of and access to the composition/document information.
                custodian: {
                  reference: arguments.organisation_urn
                },
                # Extension to carry details of the Correspondence Care Setting Type
                extension: {
                  url: "https://fhir.hl7.org.uk/STU3/StructureDefinition/Extension-CareConnect-CareSettingType-1",
                  valueCodeableConcept: {
                    coding: {
                      system: "http://snomed.info/sct",
                      code: "788003006",
                      display: "Nephrology service"
                    }
                  }
                },
                # Reference to the clinical encounter or type of care this documentation is
                # associated with.
                encounter: {
                  reference: arguments.encounter_urn
                },
                section: sections
              )
            }
          end
          # rubocop:enable Metrics/MethodLength

          # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          def sections
            [                                                         # Implemented?
              Sections::AllergiesAndAdverseReactions.call(arguments), # Y
              Sections::AssessmentScales.call(arguments),             # N/A
              Sections::AttendanceDetails.call(arguments),            # Y
              Sections::ClinicalReviewOfSystems.call(arguments),      # N/A
              Sections::ClinicalSummary.call(arguments),              # N ?
              Sections::Diagnoses.call(arguments),                    # Y
              Sections::DistributionList.call(arguments),             # Y
              Sections::ExaminationFindings.call(arguments),          # N/A
              Sections::FamilyHistory.call(arguments),                # N/A
              Sections::GPPractice.call(arguments),                   # Y
              Sections::History.call(arguments),                      # N/A
              Sections::IndividualRequirements.call(arguments),       # N/A
              Sections::InformationAndAdviceGiven.call(arguments),    # N
              Sections::InvestigationResults.call(arguments),         # N
              Sections::LegalInformation.call(arguments),             # N
              Sections::MedicationsAndMedicalDevices.call(arguments), # Y
              Sections::ParticipationInResearch.call(arguments),      # N/A
              Sections::PatientAndCarerConcerns.call(arguments),      # N/A
              Sections::PatientDemographics.call(arguments),          # Y
              Sections::PersonCompletingRecord.call(arguments),       # N
              Sections::PlanAndRequestedActions.call(arguments),      # N
              Sections::ProblemsAndIssues.call(arguments),            # N
              Sections::Procedures.call(arguments),                   # N
              Sections::ReferrerDetails.call(arguments),              # N/A
              Sections::RelevantClinicalRiskFactors.call(arguments),  # N/A
              Sections::SafetyAlerts.call(arguments),                 # N/A
              Sections::SocialContext.call(arguments)                 # N/A
            ].compact
          end
          # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
        end
      end
    end
  end
end
