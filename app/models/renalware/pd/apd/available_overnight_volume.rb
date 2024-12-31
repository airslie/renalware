module Renalware
  module PD
    module APD
      class AvailableOvernightVolume
        def initialize(regime:)
          @regime = regime
        end

        def value
          @value ||= available_overnight_volume
        end

        private

        attr_accessor :regime

        def available_overnight_volume
          unique_daily_contents = available_overnight_volumes_grouped_by_day.values.compact.uniq
          if unique_daily_contents.length != 1
            raise NonUniqueOvernightVolumeError, unique_daily_contents
          end

          unique_daily_contents.first
        end

        # Builds a hash in the format:
        # {
        #   monday: 3000,
        #   tuesday: 3000,
        #   ...
        # }
        # where the value is the combined value of all ordinary bags available on that day
        def available_overnight_volumes_grouped_by_day
          Date::DAYNAME_SYMBOLS.each_with_object({}) do |day, hash|
            hash[day] = nil
            regime.bags.select(&:ordinary?).each do |bag|
              next unless bag.volume
              next unless bag.public_send(day) == true

              hash[day] = (hash[day] || 0) + bag.volume
            end
            hash
          end
        end
      end
    end
  end
end
