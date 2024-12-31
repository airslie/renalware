module Renalware
  module LowClearance
    class DashboardsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def show
        authorize low_clearance_patient
        render :show, locals: {
          patient: low_clearance_patient,
          dashboard: dashboard_presenter
        }
      end

      private

      def dashboard_presenter
        DashboardPresenter.new(user: current_user, patient: low_clearance_patient)
      end
    end
  end
end
