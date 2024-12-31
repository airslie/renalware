module Renalware
  module Pathology
    module Requests
      class GlobalRule < ApplicationRecord
        PARAM_COMPARISON_OPERATORS = ["==", ">", "<", ">=", "<=", "include?"].freeze

        belongs_to :rule_set, polymorphic: true

        validates :rule_set, presence: true

        def observation_required_for_patient?(_patient, _date)
          raise NotImplementedError
        end

        def to_s
          raise NotImplementedError
        end
      end
    end
  end
end
