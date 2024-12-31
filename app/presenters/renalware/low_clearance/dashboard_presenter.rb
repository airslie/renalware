module Renalware
  module LowClearance
    class DashboardPresenter
      attr_reader_initialize [:patient!, :user!]
      delegate :edit?, to: :profile_policy, prefix: true

      def profile
        patient.profile || patient.build_profile
      end

      def profile_policy
        Pundit.policy!(user, profile)
      end
    end
  end
end
