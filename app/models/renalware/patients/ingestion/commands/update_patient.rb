module Renalware
  module Patients
    module Ingestion
      module Commands
        # We could be here as a results of several scenarios eg:
        # - ADT28 add patient
        # - ADT31 update patient
        class UpdatePatient < Command
          def initialize(message, mapper_factory: MessageMappers::Patient)
            @mapper_factory = mapper_factory

            super(message)
          end

          attr_reader :mapper_factory

          def call
            update_patient_if_exists
          end

          private

          def update_patient_if_exists # rubocop:disable Metrics/MethodLength
            return if ENV.key?("ADT_SKIP_UPDATE_PATIENT")

            patient = find_patient
            return if patient.blank?

            initial_died_on = patient.died_on

            patient = mapper_factory.new(message, patient).fetch
            patient.by = SystemUser.find

            patient.save!

            if patient.died_on.present? && initial_died_on.blank?
              change_patient_modality_to_death(patient)
            elsif patient.died_on.blank? && initial_died_on.present?
              notify_subscribers_of_undeceasing(patient)
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

          def notify_subscribers_of_undeceasing(patient, reason = "")
            BroadcastPatientUndeceasedEvent
              .new
              .broadcasting_to_configured_subscribers
              .call(patient, reason)
          end
        end
      end
    end
  end
end
