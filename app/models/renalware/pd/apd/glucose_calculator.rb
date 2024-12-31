module Renalware
  module PD
    module APD
      class GlucoseCalculator
        attr_reader :regime, :bags

        delegate :overnight_volume, to: :regime

        def initialize(regime:, strength:)
          @regime = regime
          @bags = bags_having_glucose_strength(regime.bags, strength)
        end

        # See calculating_apd_volumes.feature for a description of the algorithm here.
        def glucose_content
          overnight_glucose_content + other_glucose_content
        end

        private

        def overnight_glucose_content
          overnight_bags.inject(0) do |total, bag|
            total + glucose_for_bag(bag).to_i
          end
        end

        def other_glucose_content
          other_bags.inject(0) do |sum, bag|
            volume_to_use = volume_to_use_for_other_bag(bag)
            sum + (volume_to_use * bag.days_per_week)
          end.to_f / 7
        end

        # If a last fill bag has glucose content then use last_fill_volume.
        # For additional_manual_exchange bags use the bag volume.
        def volume_to_use_for_other_bag(bag)
          case bag.role.to_sym
          when :last_fill then regime.last_fill_volume
          when :additional_manual_exchange then regime.additional_manual_exchange_volume
          else raise "Unrecognised other bag type #{bag.role}"
          end
        end

        # rubocop:disable Layout/LineLength
        def glucose_for_bag(bag)
          (((bag.volume.to_f * bag.days_per_week.to_f) / available_overnight_volume.to_f) * overnight_volume) / 7
        end
        # rubocop:enable Layout/LineLength

        def available_overnight_volume
          @available_overnight_volume ||= AvailableOvernightVolume.new(regime: regime).value
        end

        def overnight_bags
          bags.select(&:ordinary?)
        end

        def other_bags
          bags - overnight_bags
        end

        def bags_having_glucose_strength(bags, strength)
          bags.select { |bag| bag.bag_type.glucose_strength == strength.to_sym }
        end
      end
    end
  end
end
