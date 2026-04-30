module Renalware
  module Medications
    class PrescriptionBatchRenewalPolicy < BasePolicy
      def create?
        auto_terminate_hd_prescriptions_after_period? && hd_prescriber?
      end
      alias new? create?

      def index? = auto_terminate_hd_prescriptions_after_period?

      private

      def hd_prescriber?
        return true unless Role.enforce?(:hd_prescriber)

        user_is_hd_prescriber? || user_is_super_admin?
      end

      def auto_terminate_hd_prescriptions_after_period?
        period = Renalware.config.auto_terminate_hd_prescriptions_after_period

        period.present? && !period.zero?
      end
    end
  end
end
