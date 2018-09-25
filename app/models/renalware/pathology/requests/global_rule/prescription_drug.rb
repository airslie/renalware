# frozen_string_literal: true

require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class PrescriptionDrug < GlobalRule
          validate :drug_present

          def observation_required_for_patient?(patient, _date)
            patient.drugs.include?(drug)
          end

          def to_s
            "prescribed drugs include #{drug.name}"
          end

          private

          def drug
            @drug ||= Drugs::Drug.find_by(id: param_id)
          end

          def drug_present
            return if drug.present?

            errors.add(:param_id, "param_id must be the id of a Drug")
          end
        end
      end
    end
  end
end
