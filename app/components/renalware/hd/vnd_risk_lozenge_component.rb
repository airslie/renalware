module Renalware
  module HD
    # Renders an individual VND Risk as a lozenge with the correct colour background according
    # to the risk level. Used when displaying an individual risk anywhere and also in the
    # VND Risk Assessment form where risks are selected.
    class VNDRiskLozengeComponent < ApplicationComponent
      pattr_initialize [:risk!]

      CSS_MAP = {
        very_low: "bg-green-300",
        low: "bg-green-400",
        medium: "bg-orange-300",
        high: "bg-red-400 text-neutral-100"
      }.freeze

      def render? = risk.present?
      def description = risk.to_s.humanize.titleize
      def call = tag.div(class: "flex rounded px-2 ml-2 py-0 #{css_classes}") { description }
      def css_classes = CSS_MAP.fetch(risk_level_without_leading_score, "")

      # maps eg "0_very_low" to :very_low
      def risk_level_without_leading_score
        risk.to_s.sub(/\d_/, "").to_sym
      end
    end
  end
end
