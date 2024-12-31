module Renalware
  module Clinical
    class DryWeightPresenter < DumbDelegator
      def assessed_on
        ::I18n.l(super)
      end

      def to_s
        "#{weight} (#{assessed_on})"
      end

      def range
        return unless minimum_weight || maximum_weight

        "(#{minimum_weight} - #{maximum_weight})"
      end
    end
  end
end
