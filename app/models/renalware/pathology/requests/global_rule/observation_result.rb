module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class ObservationResult < GlobalRule
          validates :param_comparison_operator, inclusion:
            { in: PARAM_COMPARISON_OPERATORS, allow_nil: false }
          validates :param_comparison_value, presence: true
          validate :observation_description_present

          def observation_required_for_patient?(patient, _date)
            PatientGlobalRuleDecision.new(patient, self).observation_required_for_patient?
          end

          def to_s
            "#{observation_description_code}  " \
              "#{param_comparison_operator} " \
              "#{param_comparison_value}"
          end

          def observation_description_code
            @observation_description_code ||= begin
              ObservationDescription.where(id: param_id).pick(:code)
            end
          end

          private

          def observation_description_present
            return if observation_description_code.present?

            errors.add(:param_id, "param_id must be the id of an ObservationDescription")
          end
        end

        class PatientGlobalRuleDecision
          pattr_initialize :patient, :rule
          delegate(
            :param_comparison_operator,
            :param_comparison_value,
            :param_id,
            :observation_description_code,
            to: :rule
          )

          def observation_required_for_patient?
            return true if observation.blank?

            if [">", "<", ">=", "<="].include?(rule.param_comparison_operator)
              observation.to_i.send(
                param_comparison_operator.to_sym,
                param_comparison_value.to_i
              )
            else
              observation.send(
                param_comparison_operator.to_sym,
                param_comparison_value
              )
            end
          end

          private

          def observation
            @observation ||= begin
              # This fetches the observation from the patient.current_observation_set jsonb hash.
              # The call returns eg { "result" => "123", "observed_on" => "2019-01-01" }
              ObservationForPatientObservationDescriptionUsingSetQuery.new(
                patient,
                observation_description_code
              ).call["result"]
            end
          end
        end
      end
    end
  end
end
