require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class ObservationResult < GlobalRule
          def observation_required_for_patient?(patient, _date)
            PatientGlobalRuleDecision.new(patient, self).observation_required_for_patient?
          end

          def to_s
            "#{observation_description.code} " \
            " #{param_comparison_operator} " \
            "#{param_comparison_value}"
          end

          def observation_description
            @observation_description ||= ObservationDescription.find(param_id)
          end
        end

        class PatientGlobalRuleDecision
          def initialize(patient, rule)
            @patient = patient
            @rule = rule
          end

          def observation_required_for_patient?
            return true if observation.nil?

            if [">", "<", ">=", "<="].include?(@rule.param_comparison_operator)
              observation.result.to_i.send(
                @rule.param_comparison_operator.to_sym,
                @rule.param_comparison_value.to_i
              )
            else
              observation.result.send(
                @rule.param_comparison_operator.to_sym,
                @rule.param_comparison_value
              )
            end
          end

          private

          def observation
            @observation ||=
              ObservationForPatientObservationDescriptionQuery.new(
                  @patient,
                  observation_description
                ).call
          end

          def observation_description
            @observation_description ||= ObservationDescription.new(id: @rule.param_id)
          end
        end
      end
    end
  end
end
