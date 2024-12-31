module Renalware
  module Dietetics
    class ProteinValuePresenter
      def initialize(value)
        @value = value
      end

      def to_s
        return nil unless @value

        "#{@value} g/day"
      end
    end
  end
end
