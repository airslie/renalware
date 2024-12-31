module Renalware
  module Pathology
    module Requests
      class GlobalAlgorithm
        def initialize(patient, clinic, date: Date.current)
          @patient = patient
          @clinic = clinic
          @date = date
        end

        def determine_required_request_descriptions
          rule_sets
            .select { |rule_set| rule_set.observation_required_for_patient?(@patient, @date) }
            .map(&:request_description)
            .uniq
        end

        private

        def rule_sets
          GlobalRuleSet
            .for_clinic(@clinic)
            .ordered
            .eager_load(:rules, request_description: :required_observation_description)
        end
      end
    end
  end
end
