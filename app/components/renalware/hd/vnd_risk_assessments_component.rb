module Renalware
  module HD
    class VNDRiskAssessmentsComponent < ApplicationComponent
      include Renalware::Concerns::PatientCasting
      include Renalware::IconHelper
      include Renalware::ToggleHelper

      pattr_initialize [:patient!, :current_user!, controls: true]

      def assessments
        @assessments ||= hd_patient.vnd_risk_assessments.ordered.take(4)
      end

      def render?
        assessments.any?
      end
    end
  end
end
