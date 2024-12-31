module Renalware
  module Accesses
    class AssessmentFactory
      attr_reader :patient

      def initialize(patient:)
        @patient = patient
      end

      def build
        assessment = build_assessment
        apply_default_access(assessment)
        assessment
      end

      private

      def build_assessment
        @patient.assessments.new(
          performed_on: Time.zone.today
        )
      end

      def apply_default_access(assessment)
        if (profile = @patient.current_profile)
          assessment.type = profile.type
          assessment.side = profile.side
        end
      end
    end
  end
end
