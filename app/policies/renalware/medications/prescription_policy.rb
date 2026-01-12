module Renalware
  module Medications
    class PrescriptionPolicy < BasePolicy
      include PrescriberPolicyHelpers

      def new?                  = super && prescriber?
      def create?               = super && prescriber?
      def edit?                 = super && (administer_on_hd? ? hd_prescriber? : prescriber?)
      def update?               = super && (administer_on_hd? ? hd_prescriber? : prescriber?)
      def destroy?              = super && (administer_on_hd? ? hd_prescriber? : prescriber?)
      def new_hd_prescription?  = hd_prescriber?

      private

      def administer_on_hd? = record&.administer_on_hd
    end
  end
end
