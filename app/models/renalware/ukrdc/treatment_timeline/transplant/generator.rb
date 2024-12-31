# QBL   TXT   Description
# "20"  "20"  "Transplant ; Cadaver donor"
# "21"  "21"  "Transplant ; Live related - sibling"
# "74"  "74"  "Transplant ; Live related - father"
# "75"  "75"  "Transplant ; Live related - mother"
# "77"  "77"  "Transplant ; Live related - child"
# "23"  "23"  "Transplant ; Live related - other"
# "24"  "24"  "Transplant ; Live genetically unrelated"
# "25"  "25"  "Transplant ; Cadaver donor + transp other organ"
# "26"  "26"  "Transplant ; Live donor + transplant other organ"
# "27"  "27"  "Transplant ; Live donor non-UK transplant"
# "28"  "28"  "Transplant ; non-heart-beating donor"
# "29"  "29"  "Transplant ; type unknown"
module Renalware
  module UKRDC
    module TreatmentTimeline
      module Transplant
        class Generator
          pattr_initialize :modality
          delegate :patient, to: :modality
          attr_reader :operation

          UKRR_TXT = {
            cadaver: 20,
            unknown: 29,
            live_related_other: 23,
            live_related_sibling: 21,
            live_related_father: 74,
            live_related_mother: 75,
            live_related_child: 77,
            non_heart_beating: 28,
            live_unrelated: 24
          }.freeze

          # We need to create a treatment record to match the UKRDC code expectations
          # based on donor relationship.
          # Otherwise Default to 29 Transplant ; type unknown
          def call
            @operation = first_operation_within_start_and_end_dates_of_modality
            create_treatment
          end

          private

          def create_treatment
            Treatment.create!(
              patient: modality.patient,
              clinician: modality.created_by,
              started_on: modality.started_on,
              modality_id: modality.id,
              modality_description_id: modality.description_id,
              ended_on: modality.ended_on,
              modality_code: ukrr_modality_code
            )
          end

          def unknown_transplant_ukrr_modality_code
            ukrr_modality_code_for_txt(UKRR_TXT[:unknown])
          end

          def ukrr_modality_code
            return unknown_transplant_ukrr_modality_code if operation.nil?
            return unknown_transplant_ukrr_modality_code if donor_type.nil?

            if donor_type == :live_related
              ukrr_modality_code_for_live_donor_relationship
            else
              ukrr_modality_code_for_txt(UKRR_TXT[donor_type])
            end
          end

          def donor_type
            operation.document.donor.type&.to_sym
          end

          def donor_relationship
            operation.document.donor.relationship&.to_sym
          end

          def ukrr_modality_code_for_live_donor_relationship
            key = :"live_related_#{donor_relationship || 'other'}"
            ukrr_modality_code_for_txt(UKRR_TXT.fetch(key))
          end

          def ukrr_modality_code_for_txt(txt_code)
            UKRDC::ModalityCode.find_by(txt_code: txt_code)
          end

          def first_operation_within_start_and_end_dates_of_modality
            Renalware::Transplants::RecipientOperation
              .for_patient(patient)
              .where(performed_on: modality.started_on..(modality.ended_on || Time.zone.today))
              .order(performed_on: :desc)
              .first
          end
        end
      end
    end
  end
end
