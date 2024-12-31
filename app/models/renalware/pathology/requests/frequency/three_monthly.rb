module Renalware
  module Pathology
    module Requests
      class Frequency::ThreeMonthly < Frequency
        def observation_required?(last_observed_on)
          last_observed_on > 90
        end
      end
    end
  end
end
