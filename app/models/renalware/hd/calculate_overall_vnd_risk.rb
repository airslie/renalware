module Renalware
  module HD
    class CalculateOverallVNDRisk
      include Callable

      pattr_initialize :vnd_risk_assessment

      def call
        {
          overall_risk_score: overall_risk_score,
          overall_risk_level: overall_risk_level
        }
      end

      def overall_risk_score
        @overall_risk_score ||= vnd_risk_assessment
          .slice(%i(risk1 risk2 risk3 risk4))
          .values
          .sum(&:to_i)
      end

      def overall_risk_level
        case overall_risk_score
        when 3..4 then :medium
        when 5.. then :high
        else :low
        end
      end
    end
  end
end
