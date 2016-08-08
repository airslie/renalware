module Renalware
  module Pathology
    module Requests
      class GlobalRuleSet
        class PatientRuleSetDecision
          OBSERVATION_REQUIRED = true
          OBSERVATION_NOT_REQUIRED = false

          def initialize(patient, rule_set)
            @rule_set = rule_set
            @patient = patient
          end

          # NOTE: Decide if a rule_set applies to a patient
          def call
            if last_observation.present?
              return OBSERVATION_NOT_REQUIRED if last_observation_too_recent?
            end

            if last_request.present?
              return OBSERVATION_NOT_REQUIRED if last_request_still_being_processed?
            end

            if required_from_rules?
              OBSERVATION_REQUIRED
            else
              OBSERVATION_NOT_REQUIRED
            end
          end

          private

          def last_observation_too_recent?
            observed_days_ago = date_today - last_observation.observed_on
            !@rule_set.frequency.observation_required?(observed_days_ago)
          end

          def last_request_still_being_processed?
            return false if last_request_has_an_observation_result?

            expiration_days = @rule_set.request_description.expiration_days
            return false if expiration_days == 0

            requested_days_ago = date_today - last_request.requested_on
            requested_days_ago < expiration_days
          end

          def required_from_rules?
            @rule_set.rules
              .map { |rule| rule.required_for_patient?(@patient) }
              .all?
          end

          def last_request_has_an_observation_result?
            last_observation.present? &&
              last_observation.observed_on > last_request.requested_on
          end

          def last_observation
            @last_observation ||=
              ObservationForPatientRequestDescriptionQuery.new(
                @patient,
                @rule_set.request_description
              ).call
          end

          def last_request
            @last_request ||=
              RequestForPatientRequestDescriptionQuery.new(
                @patient,
                @rule_set.request_description
              ).call
          end

          def date_today
            @date_today ||= Date.current
          end
        end
      end
    end
  end
end
