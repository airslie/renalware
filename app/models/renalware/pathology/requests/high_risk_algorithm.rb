module Renalware
  module Pathology
    module Requests
      class HighRiskAlgorithm
        def initialize(patient)
          @patient = patient
        end

        def patient_is_high_risk?
          rules
            .map { |rule| rule.observation_required_for_patient?(@patient, Date.current) }
            .any?
        end

        def id
          nil
        end

        private

        def rules
          HighRiskRuleSet.rules
        end
      end
    end
  end
end
