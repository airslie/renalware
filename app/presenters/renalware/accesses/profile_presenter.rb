module Renalware
  module Accesses
    class ProfilePresenter < DumbDelegator
      def formed_on       = ::I18n.l(super)
      def started_on      = ::I18n.l(super)
      def terminated_on   = ::I18n.l(super)
      def side            = super.try(:text)
      def plan_type       = current_plan&.plan_type.to_s
      def plan_date       = current_plan&.created_at
      def type            = super

      private

      def current_plan
        @current_plan ||= patient.current_plan
      end
    end
  end
end
