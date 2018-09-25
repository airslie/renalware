# frozen_string_literal: true

require_dependency "renalware/pd"
require_dependency "renalware/pd/apd/glucose_calculator"

module Renalware
  module PD
    module APD
      class CalculateVolumes
        def initialize(regime)
          raise ArgumentError("Not an APD regime") unless regime.apd?

          @regime = decorate(regime)
        end

        # rubocop:disable Metrics/AbcSize
        def call
          regime.overnight_volume = regime.calculated_overnight_volume
          regime.daily_volume = regime.calculated_daily_volume
          regime.glucose_volume_low_strength = regime.volume_of_glucose_at_strength(:low)
          regime.glucose_volume_medium_strength = regime.volume_of_glucose_at_strength(:medium)
          regime.glucose_volume_high_strength = regime.volume_of_glucose_at_strength(:high)
        end
        # rubocop:enable Metrics/AbcSize

        private

        attr_reader :regime

        def decorate(regime)
          klass = regime.tidal? ? TidalRegimeCalculations : NonTidalRegimeCalculations
          klass.new(regime)
        end
      end
    end
  end
end
