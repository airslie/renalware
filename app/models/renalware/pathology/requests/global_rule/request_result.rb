module Renalware
  module Pathology
    module Requests
      class GlobalRule
        class RequestResult < GlobalRule
          validates :param_comparison_operator, inclusion:
            { in: PARAM_COMPARISON_OPERATORS, allow_nil: false }
          validates :param_comparison_value, presence: true
          validate :request_description_present
          validate :required_observation_description_for_request_description_present

          def observation_required_for_patient?(patient, _date)
            observation =
              ObservationForPatientObservationDescriptionQuery.new(
                patient, observation_description
              ).call
            observation_result = observation.result.to_i if observation.present?

            return true if observation_result.nil?

            observation_result.send(param_comparison_operator.to_sym, param_comparison_value.to_i)
          end

          def to_s
            "last result is #{param_comparison_operator} #{param_comparison_value}"
          end

          private

          def observation_description
            request_description.required_observation_description
          end

          def request_description
            RequestDescription.eager_load(:required_observation_description).find_by(id: param_id)
          end

          def request_description_present
            return if request_description.present?

            errors.add(:param_id, "param_id must be the id of an RequestDescription")
          end

          def required_observation_description_for_request_description_present
            return if request_description.present? &&
                      request_description.required_observation_description.present?

            errors.add(:request_description, "required observation description can't be blank")
          end
        end
      end
    end
  end
end
