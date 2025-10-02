# frozen_string_literal: true

module Renalware
  module Admissions
    module Ingestion
      module Commands
        # Handles ADT^A11 messages to cancel (delete) a previously created admission.
        # An A11 message indicates that an admission was entered in error and should be removed.
        class CancelAdmission
          include Callable

          pattr_initialize :message
          delegate :patient_identification, :pv1, to: :message
          delegate :visit_number, to: :pv1

          def call
            return unless patient_exists_in_renalware?

            delete_admission_with_matching_visit_number
          end

          private

          def patient_exists_in_renalware?
            patient.present?
          end

          def delete_admission_with_matching_visit_number
            admission = find_admission_with_matching_visit_number
            # Use really_destroy! to permanently delete the record (acts_as_paranoid gem)
            # rather than soft-delete with destroy which only sets deleted_at
            admission&.destroy!
          end

          def find_admission_with_matching_visit_number
            Admission
              .where(patient: patient)
              .where(visit_number: visit_number)
              .order(created_at: :desc)
              .first
          end

          def patient
            @patient ||= Feeds::PatientLocator.call(
              :adt,
              patient_identification: patient_identification
            )
          end
        end
      end
    end
  end
end
