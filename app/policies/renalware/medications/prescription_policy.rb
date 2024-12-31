module Renalware
  module Medications
    class PrescriptionPolicy < BasePolicy
      def new?                  = super && prescriber?
      def create?               = super && prescriber?
      def edit?                 = super && (administer_on_hd? ? hd_prescriber? : prescriber?)
      def update?               = super && (administer_on_hd? ? hd_prescriber? : prescriber?)
      def destroy?              = super && (administer_on_hd? ? hd_prescriber? : prescriber?)
      def new_hd_prescription?  = hd_prescriber?

      private

      def hd_prescriber?
        return true unless Role.enforce?(:hd_prescriber)

        user_is_hd_prescriber? || user_is_super_admin?
      end

      def prescriber?
        return true unless Role.enforce?(:prescriber)

        user_is_prescriber? || user_is_hd_prescriber? || user_is_super_admin?
      end

      def administer_on_hd?
        record&.administer_on_hd
      end
    end
  end
end
