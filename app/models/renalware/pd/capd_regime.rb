module Renalware
  module PD
    class CAPDRegime < Regime
      include OrderedScope
      include PatientScope

      enumerize :assistance_type, in: %i(
        none
        1_visit_per_day
        2_visits_per_day
        3_visits_per_day
        4_visits_per_day
      )

      BAG_VOLUMES = [
        500, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2200, 2500
      ].freeze

      before_save :calculate_daily_average_glucose_volumes

      def pd_type
        :capd
      end

      private

      def calculate_daily_average_glucose_volumes
        strengths = build_hash_of_glucose_strengths_and_bag_glucose_volumes
        persist_daily_average_glucose_volume_for_each_strength(strengths)
      end

      def build_hash_of_glucose_strengths_and_bag_glucose_volumes
        strengths = initialise_hash_of_glucose_strengths
        assign_weekly_glucose_volume_for_each_bag_to_corresponding_strength(strengths)
        strengths
      end

      def persist_daily_average_glucose_volume_for_each_strength(strengths)
        strengths.each do |name, strength|
          strength_setter = :"glucose_volume_#{name}_strength="
          send(strength_setter, strength.daily_average) if respond_to?(strength_setter)
        end
      end

      def initialise_hash_of_glucose_strengths
        BagType.glucose_strength.values.each_with_object({}) do |strength, hash|
          hash[strength.to_sym] = GlucoseStrength.new
        end
      end

      def assign_weekly_glucose_volume_for_each_bag_to_corresponding_strength(strengths)
        bags.each do |bag|
          weekly_total = bag.weekly_total_glucose_ml_per_bag
          bag_strength = bag.bag_type.glucose_strength.to_sym
          strengths[bag_strength].weekly_totals << weekly_total
        end
      end

      class GlucoseStrength
        attr_reader :weekly_totals

        def initialize
          @weekly_totals = []
        end

        def daily_average
          per_week_total = weekly_totals.sum(0.0)
          per_week_total / 7.to_f
        end
      end
    end
  end
end
