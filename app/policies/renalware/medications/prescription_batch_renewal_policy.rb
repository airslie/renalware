# frozen_string_literal: true

module Renalware
  module Medications
    class PrescriptionBatchRenewalPolicy < BasePolicy
      def new?
        super && hd_prescriber?
      end

      private

      def hd_prescriber?
        return true unless Role.enforce?(:hd_prescriber)

        user_is_hd_prescriber? || user_is_super_admin?
      end
    end
  end
end
