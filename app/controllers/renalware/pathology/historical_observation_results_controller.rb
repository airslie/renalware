# frozen_string_literal: true

module Renalware
  module Pathology
    class HistoricalObservationResultsController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::Pageable

      def index
        authorize pathology_patient
        observations_table = CreateObservationsGroupedByDateTable.new(
          patient: pathology_patient,
          observation_descriptions: ObservationDescription.in_display_order,
          page: page || 1,
          per_page: 25
        ).call

        render :index, locals: { table: observations_table, patient: pathology_patient }
      end
    end
  end
end
