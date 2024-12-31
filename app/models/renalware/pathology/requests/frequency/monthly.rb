module Renalware
  module Pathology
    module Requests
      class Frequency::Monthly < Frequency
        def observation_required?(last_observed_on)
          last_observed_on > 28
        end
      end
    end
  end
end
