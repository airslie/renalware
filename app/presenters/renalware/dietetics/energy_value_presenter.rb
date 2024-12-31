module Renalware
  module Dietetics
    class EnergyValuePresenter
      def initialize(value)
        @value = value
      end

      def to_s
        return nil unless @value

        "#{@value} kcal/day"
      end
    end
  end
end
