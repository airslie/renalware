# frozen_string_literal: true

require_dependency "renalware/pathology/requests/frequency"

module Renalware
  module Pathology
    module Requests
      class Frequency::Yearly < Frequency
        def observation_required?(last_observed_on)
          last_observed_on > 360
        end
      end
    end
  end
end
