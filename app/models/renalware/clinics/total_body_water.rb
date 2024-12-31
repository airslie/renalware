# Total Body Water (TBW) calculated using WATSON
# References:
# - https://qxmd.com/calculate/calculator_344/total-body-water-watson-formula
#
# Total Body Water
#   TBW = 2.447 - 0.09156 X age + 0.1074 X height + 0.3362 X weight
#   (females) TBW = -2.097 + 0.1069 X height + 0.2466 X weight
#
# Water in Litres
# Age in years
# Height in cm
# Weight in kg
module Renalware
  module Clinics
    class TotalBodyWater
      pattr_initialize [:height!, :weight!, :age, :sex]

      NOTHING = nil
      SEX_PROC_MAP = {
        M: ->(age:, height:, weight:) {
          2.447 - (0.09156 * age) + (0.1074 * height) + (0.3362 * weight)
        },
        F: ->(height:, weight:, **) {
          -2.097 + (0.1069 * height) + (0.2466 * weight)
        }
      }.freeze
      NOOP = ->(**) { NullObject.instance }

      def self.calculate(dp: 2, **)
        new(**).calculate(dp: dp)
      end

      def calculate(dp: 2)
        return NOTHING if height_cm.zero?
        return NOTHING if weight_kg.zero?
        return NOTHING if age.to_i.zero?

        proc_for_sex = SEX_PROC_MAP.fetch(sex_sym, NOOP)

        proc_for_sex.call(
          age: age,
          height: height_cm,
          weight: weight_kg
        ).round(dp)
      end

      private

      # Note sex can be nil but here that would evaluate to :""
      def sex_sym
        sex.to_s&.to_sym
      end

      def height_cm
        height.to_f * 100
      end

      def weight_kg
        weight.to_f
      end
    end
  end
end
