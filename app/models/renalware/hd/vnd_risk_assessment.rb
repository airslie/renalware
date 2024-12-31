module Renalware
  module HD
    class VNDRiskAssessment < ApplicationRecord
      include Accountable
      acts_as_paranoid
      belongs_to :patient, touch: true
      validates :patient, presence: true
      validates :risk1, presence: true
      validates :risk2, presence: true
      validates :risk3, presence: true
      validates :risk4, presence: true
      validates :overall_risk_score, presence: true, numericality: { in: 0..8, only_integer: true }
      validates :overall_risk_level, presence: true

      before_validation :calculate_overall_risk

      scope :ordered, -> { order(updated_at: :desc) }

      def self.current = ordered.first

      # The overall_risk is the sum of risks 1 to 4.
      # Wwe use #to_i on risk1, risk2 etc as they will have string enum values like "0_very_low",
      # and so we can rely on ruby's #to_i implementation i.e.:
      #   "0_very_low".to_i == 0
      #   "2_high".to_i == 2
      def calculate_overall_risk
        assign_attributes(CalculateOverallVNDRisk.call(self))
      end

      def overall_risk
        [
          overall_risk_score,
          overall_risk_level&.humanize
        ].compact.uniq.join(" ")
      end
    end
  end
end
