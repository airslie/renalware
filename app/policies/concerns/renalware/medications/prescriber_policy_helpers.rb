module Renalware
  module Medications
    module PrescriberPolicyHelpers
      extend ActiveSupport::Concern

      def hd_prescriber?
        return true unless Role.enforce?(:hd_prescriber)

        user_is_hd_prescriber? || user_is_super_admin?
      end

      def prescriber?
        return true unless Role.enforce?(:prescriber)

        user_is_prescriber? || user_is_hd_prescriber? || user_is_super_admin?
      end

      def administer_on_hd? = record&.administer_on_hd
    end
  end
end
