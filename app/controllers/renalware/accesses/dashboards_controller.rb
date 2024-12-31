require "collection_presenter"

module Renalware
  module Accesses
    class DashboardsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def show
        authorize accesses_patient
        render locals: { dashboard: DashboardPresenter.new(accesses_patient) }
      end
    end
  end
end
