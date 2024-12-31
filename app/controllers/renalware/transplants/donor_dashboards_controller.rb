module Renalware
  module Transplants
    class DonorDashboardsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def show
        authorize transplants_patient
        render locals: { dashboard: DonorDashboardPresenter.new(transplants_patient) }
      end
    end
  end
end
