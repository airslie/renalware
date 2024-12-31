module Renalware
  module Medications
    class PrescriptionBatchRenewalPolicy < BasePolicy
      def create?
        auto_terminate_hd_prescriptions_after_period? && hd_prescriber?
      end
      alias new? create?

      private

      def hd_prescriber?
        return true unless Role.enforce?(:hd_prescriber)

        user_is_hd_prescriber? || user_is_super_admin?
      end

      def auto_terminate_hd_prescriptions_after_period?
        Renalware.config.auto_terminate_hd_prescriptions_after_period.present?
      end
    end
  end
end
