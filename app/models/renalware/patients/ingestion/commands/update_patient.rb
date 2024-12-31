module Renalware
  module Patients
    module Ingestion
      module Commands
        # We could be here as a results of 2 scenarios:
        # - ADT28 add patient
        # - ADT31 update patient
        #
        # In both circumstances our action is the same:
        # 1. If the patient exists as a Renalware::Patient, update their details
        # 2. Find or create a Patients::Abridgement for this patient
        # 3. Update their abridgement info, including their Renalware::Patient id if one exists
        #
        # So basically we are maintaining patient data in 2 places:
        # a) in Renalware::Patient and its associated address and demographics tables
        # b) in Renalware::Patients::Abridgement, which is an abbreviated version of the patient's
        #    details (name, numbers, DOB ect), enabling us to find and import a new patient by
        #    taking the abridgement, finding all previously received ADT and ORU etc feed_messages
        #    for the patient and replaying those messages to build the patient with their
        #    and pathology. If a patient is already a Renalware::Patient then in theory we do
        #    not need to maintain an abridgement for them, but for consistency we do; it has
        #    advantages when trying to add a new patient in the Renalware UI - e.g. it can show you
        #    that that patient is already added because there is a patient_id on the abridgement.
        class UpdatePatient < Command
          def initialize(message, mapper_factory: MessageMappers::Patient)
            @mapper_factory = mapper_factory

            super(message)
          end

          attr_reader :mapper_factory

          def call
            update_patient_if_exists
            UpdateMasterPatientIndex.new(message).call
          end

          private

          def update_patient_if_exists
            return if ENV.key?("ADT_SKIP_UPDATE_PATIENT")

            patient = find_patient
            return if patient.blank?

            initial_died_on = patient.died_on

            patient = mapper_factory.new(message, patient).fetch
            patient.by = SystemUser.find

            patient.save!

            if patient.died_on.present? && initial_died_on.blank?
              change_patient_modality_to_death(patient)
            end

            patient
          end

          def find_patient
            Feeds::PatientLocator.call(
              :adt,
              patient_identification: message.patient_identification
            )
          end

          # Change patient modality to Death and make sure we call
          # wire up broadcasting to subscribers so that when ChangePatientModality
          # broadcasts a #patient_modality_changed_to_death message, configured listeners (see the
          # broadcast_map config) will take relevant action to tidy up the patient's data
          # (search for patient_modality_changed_to_death).
          def change_patient_modality_to_death(patient)
            result = Modalities::ChangePatientModality.new(
              patient: patient,
              user: Renalware::SystemUser.find
            )
              .broadcasting_to_configured_subscribers
              .call(
                description: Deaths::ModalityDescription.first!,
                started_on: Time.zone.now
              )
            raise(ActiveModel::ValidationError, result.object) if result.failure?
          end
        end
      end
    end
  end
end
