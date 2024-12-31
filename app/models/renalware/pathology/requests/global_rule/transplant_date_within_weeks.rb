module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class TransplantDateWithinWeeks < GlobalRule
          validates :param_comparison_value, presence: true

          def observation_required_for_patient?(patient, date)
            most_recent_operation =
              Transplants::RecipientOperation.for_patient(patient).most_recent
            return false if most_recent_operation.blank?

            latest_date_possible = date - param_comparison_value.to_i.weeks

            most_recent_operation.performed_on > latest_date_possible
          end

          def to_s
            "transplant date within #{param_comparison_value} weeks ago"
          end
        end
      end
    end
  end
end
