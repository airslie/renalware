module Renalware
  module PD
    class DashboardsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def show
        authorize pd_patient
        render :show, locals: {
          patient: pd_patient,
          dashboard: DashboardPresenter.new(pd_patient)
        }
      end
    end
  end
end
