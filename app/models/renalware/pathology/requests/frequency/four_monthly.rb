module Renalware
  module Pathology
    module Requests
      class Frequency::FourMonthly < Frequency
        def observation_required?(last_observed_on)
          last_observed_on > 120
        end
      end
    end
  end
end
