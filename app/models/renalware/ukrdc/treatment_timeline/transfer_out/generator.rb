module Renalware
  module UKRDC
    module TreatmentTimeline
      module TransferOut
        class Generator
          RR7_DISCHARGE_CODE_TRANSFER_OUT = 38
          pattr_initialize :modality
          delegate :patient, to: :modality

          def call
            update_discharge_reason_on_most_recent_treatment
          end

          private

          def most_recent_treatment
            @most_recent_treatment ||= begin
              Treatment.where(patient_id: patient.id).order(started_on: :desc).first
            end
          end

          def update_discharge_reason_on_most_recent_treatment
            return if most_recent_treatment.blank?

            most_recent_treatment.update!(
              discharge_reason_code: RR7_DISCHARGE_CODE_TRANSFER_OUT,
              discharge_reason_comment: "transfer_out"
            )
          end
        end
      end
    end
  end
end
