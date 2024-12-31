module Renalware
  module UKRDC
    module TreatmentTimeline
      module Generic
        # Handles creating a treatment record for any modality that has not been handled in a more
        # specific way. Note that we only create a Treatment if we find a ukrdc_modality_code_id
        # in the modality's description row in the database. Some modalities will not have that
        # id so we just ignore them.
        class Generator
          pattr_initialize :modality

          def call
            create_treatment if ukrdc_modality_code.present?
          end

          private

          def ukrdc_modality_code
            @ukrdc_modality_code ||= begin
              UKRDC::ModalityCode.find_by(
                id: modality.description.ukrdc_modality_code_id
              )
            end
          end

          def create_treatment
            Treatment.create!(
              patient: modality.patient,
              clinician: modality.created_by,
              started_on: modality.started_on,
              modality_id: modality.id,
              modality_description_id: modality.description_id,
              ended_on: modality.ended_on,
              modality_code: ukrdc_modality_code
            )
          end
        end
      end
    end
  end
end
