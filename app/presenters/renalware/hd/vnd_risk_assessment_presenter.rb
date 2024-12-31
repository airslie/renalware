module Renalware
  module HD
    class VNDRiskAssessmentPresenter
      include ActionView::Helpers
      pattr_initialize :assessment
      delegate :to_param, to: :assessment

      CSS_MAP = {
        very_low: "bg-green-300",
        low: "bg-green-400",
        medium: "bg-orange-300",
        high: "bg-red-400 text-neutral-100"
      }.freeze

      class << self
        delegate_missing_to VNDRiskAssessment
      end
      delegate_missing_to :assessment

      def css_classes_for(level)= CSS_MAP.fetch(level&.to_sym, "")
    end
  end
end
