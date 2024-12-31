module Renalware
  module Pathology
    module Requests
      class Frequency::Always < Frequency
        def observation_required?(_last_observed_on)
          true
        end
      end
    end
  end
end
