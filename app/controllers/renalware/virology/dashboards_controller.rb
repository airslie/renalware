# frozen_string_literal: true

module Renalware
  module Virology
    class DashboardsController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::PatientCasting

      def show
        virology_patient
        authorize [:renalware, :virology, :dashboard], :show?
        render locals: { dashboard: DashboardPresenter.new(virology_patient) }
      end
    end
  end
end
