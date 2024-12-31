module Renalware
  module Pathology
    module Requests
      class Frequency::Once < Frequency
        # NOTE: The Frequency module will only be called if there was a previous observation
        # so an observation is never required if this method gets called.
        def observation_required?(_last_observed_on)
          false
        end

        def once?
          true
        end
      end
    end
  end
end
