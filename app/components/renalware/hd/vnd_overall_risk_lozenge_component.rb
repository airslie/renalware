module Renalware
  module HD
    # Renders an individual VND Risk as a lozenge with the correct colour background according
    # to the risk level. Used when displaying an individual risk anywhere and also in the
    # VND Risk Assessment form where risks are selected.
    class VNDOverallRiskLozengeComponent < ApplicationComponent
      pattr_initialize [:assessment!]
      delegate :overall_risk_level, :overall_risk_score, :overall_risk, to: :assessment

      def render?
        overall_risk_level.present? && overall_risk_score.present?
      end

      def description = overall_risk

      def call
        tag.div(class: "rounded inline px-2 py-px text-center #{css_classes}") { description }
      end

      private

      def css_classes
        case overall_risk_score.to_i
        when 0..2 then "bg-green-600 text-white"
        when 3..4 then "bg-orange-400 text-white"
        else "bg-red-600 text-white"
        end
      end
    end
  end
end
