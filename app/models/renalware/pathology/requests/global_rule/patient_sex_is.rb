module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class PatientSexIs < GlobalRule
          validates :param_comparison_value, inclusion: { in: %w(M F), allow_nil: false }

          def observation_required_for_patient?(patient, _date)
            patient.sex.code == param_comparison_value
          end

          def to_s
            "patient is #{param_comparison_value}"
          end
        end
      end
    end
  end
end
