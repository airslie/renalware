module Renalware
  module Accesses
    class DashboardPresenter
      attr_reader_initialize :patient

      def profiles
        @profiles ||= CollectionPresenter.new(
          patient.profiles.ordered.includes(:type),
          ProfilePresenter
        )
      end

      def plans
        @plans ||= CollectionPresenter.new(
          patient.plans.ordered,
          PlanPresenter
        )
      end

      def procedures
        @procedures ||= CollectionPresenter.new(
          patient.procedures.ordered.includes(:type),
          ProcedurePresenter
        )
      end

      def assessments
        @assessments ||= CollectionPresenter.new(
          patient.assessments.ordered.includes(:type),
          AssessmentPresenter
        )
      end

      def current_profile
        @current_profile ||= ProfilePresenter.new(patient.current_profile)
      end

      def current_plan
        @current_plan ||= ProfilePresenter.new(patient.current_plan)
      end
    end
  end
end
