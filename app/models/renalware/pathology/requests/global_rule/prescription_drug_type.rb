module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class PrescriptionDrugType < GlobalRule
          validate :drug_type_present

          def observation_required_for_patient?(patient, _date)
            patient
              .prescriptions.current.joins(drug: :drug_type_classifications)
              .where("drug_types_drugs.drug_type_id = ?", param_id)
              .count > 0
          end

          def to_s
            "prescribed drugs include #{drug_type.name}"
          end

          private

          def drug_type
            @drug_type ||= Drugs::Type.find_by(id: param_id)
          end

          def drug_type_present
            return if Drugs::Type.exists?(param_id)

            errors.add(:param_id, "param_id must be the id of a DrugType")
          end
        end
      end
    end
  end
end
