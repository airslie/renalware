# frozen_string_literal: true

module Renalware
  module Accesses
    class ProfilePresenter < DumbDelegator
      def formed_on
        ::I18n.l(super)
      end

      def started_on
        ::I18n.l(super)
      end

      def terminated_on
        ::I18n.l(super)
      end

      def side
        super.try(:text)
      end

      def plan_type
        current_plan.plan_type.to_s
      end

      def plan_date
        current_plan.created_at
      end

      def type
        super
      end

      private

      def current_plan
        @current_plan ||= patient.current_plan || NullObject.instance
      end
    end
  end
end
