module Renalware
  module Transplants
    class RecipientDashboardsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def show
        authorize transplants_patient
        render locals: { dashboard: RecipientDashboardPresenter.new(transplants_patient) }
      end
    end
  end
end
