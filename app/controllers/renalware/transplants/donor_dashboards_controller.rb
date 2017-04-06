require_dependency "renalware/transplants/base_controller"

module Renalware
  module Transplants
    class DonorDashboardsController < BaseController
      before_action :load_patient

      def show
        render locals: {
          patient: patient,
          donations: Donation.for_patient(patient).reversed,
          donor_workup: DonorWorkup.for_patient(patient).first_or_initialize,
          donor_operations: DonorOperation.for_patient(patient).reversed,
          donor_stages: DonorStage.for_patient(patient).ordered
        }
      end
    end
  end
end
