module Renalware
  module PD
    module APD
      class NonTidalRegimeCalculations < RegimeCalculations
        def calculated_overnight_volume
          return INCALCULABLE unless volume_calculable?

          fill_volume * cycles
        end

        private

        def volume_calculable?
          fill_volume.to_i.positive? && cycles.to_i.positive?
        end
      end
    end
  end
end
