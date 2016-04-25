require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module RequestAlgorithm
      module FrequencyMethods
        extend ActiveSupport::Concern

        private

        def required_from_frequency?(frequency, days_ago_observed)
          if frequency == "Always"
            true
          elsif frequency == "Once"
            false
          elsif frequency == "Weekly"
            days_ago_observed >= 7
          elsif frequency == "Monthly"
            days_ago_observed >= 28
          end
        end
      end
    end
  end
end
