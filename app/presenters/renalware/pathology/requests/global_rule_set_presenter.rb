module Renalware
  module Pathology
    module Requests
      class GlobalRuleSetPresenter < SimpleDelegator
        def self.present(rule_sets)
          rule_sets.map { |rule_set| new rule_set }
        end
      end
    end
  end
end
