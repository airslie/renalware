module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class PatientIsDiabetic < GlobalRule
          validates :param_comparison_value, inclusion: { in: %w(true false), allow_nil: false }

          def observation_required_for_patient?(patient, _date)
            patient.diabetic? == param_comparison_boolean
          end

          def to_s
            if param_comparison_boolean
              "patient is DM"
            else
              "patient is not DM"
            end
          end

          def param_comparison_boolean
            param_comparison_value&.casecmp("true") == 0
          end
        end
      end
    end
  end
end
