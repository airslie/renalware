module Renalware
  module Clinics
    class WeightValuePresenter
      def initialize(value)
        @value = value
      end

      def to_s
        return nil unless @value

        "#{@value} kg"
      end
    end
  end
end
