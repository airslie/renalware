require_relative "glucose_calculator"

module Renalware
  module PD
    module APD
      class RegimeCalculations < SimpleDelegator
        INCALCULABLE = nil

        def calculated_overnight_volume
          raise NotImplementedAError
        end

        #  The total volume of all bags for a day when they have PD.
        def calculated_daily_volume
          vol = [
            calculated_overnight_volume,
            effective_last_fill_volume,
            effective_additional_manual_exchange_volume
          ].compact.sum
          vol == 0 ? nil : vol
        end

        def volume_of_glucose_at_strength(strength)
          raise "Overnight volume must be calculated first" if overnight_volume.blank?

          GlucoseCalculator.new(regime: self, strength: strength).glucose_content
        end

        private

        def effective_last_fill_volume
          has_last_fill_bag? ? last_fill_volume : 0
        end

        def effective_additional_manual_exchange_volume
          has_additional_manual_exchange_bag? ? additional_manual_exchange_volume : 0
        end
      end
    end
  end
end
