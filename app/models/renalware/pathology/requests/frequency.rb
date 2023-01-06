# frozen_string_literal: true

module Renalware
  module Pathology
    module Requests
      class Frequency
        def observation_required?(_days)
          raise NotImplementedError
        end

        def once?
          false
        end

        def to_s
          self.class.name.demodulize
        end

        def self.all_names
          %w(Always Once Weekly Monthly TwoMonthly ThreeMonthly FourMonthly SixMonthly Yearly)
        end
      end
    end
  end
end
