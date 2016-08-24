require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class TransplantDateWithinWeeks < GlobalRule
          def observation_required_for_patient?(patient, date)
            most_recent_operation =
              Transplants::RecipientOperation.for_patient(patient).most_recent
            return false unless most_recent_operation.present?

            latest_date_possible = date - param_comparison_value.to_i.weeks

            most_recent_operation.performed_on > latest_date_possible
          end

          def to_s
            "transplant date within #{@param_comparison_value} weeks ago"
          end
        end
      end
    end
  end
end
