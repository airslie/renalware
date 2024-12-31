module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class PrescriptionDrugCategory < GlobalRule
          validate :drug_category_present

          def observation_required_for_patient?(patient, _date)
            (patient.current_drug_ids & drug_ids).any?
          end

          def to_s
            "prescribed drugs include #{drug_category.name}"
          end

          private

          def drug_ids
            drug_category.drugs.pluck(:id)
          end

          def drug_category
            DrugCategory.find_by(id: param_id)
          end

          def drug_category_present
            return if drug_category.present?

            errors.add(:param_id, "param_id must be the id of a DrugCategory")
          end
        end
      end
    end
  end
end
