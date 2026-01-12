module Renalware
  module Medications
    class PrescriptionTerminationPolicy < BasePolicy
      include PrescriberPolicyHelpers

      def create? = super && (administer_on_hd? ? hd_prescriber? : prescriber?)
      alias new? create?

      private

      def administer_on_hd? = record&.prescription&.administer_on_hd
    end
  end
end
