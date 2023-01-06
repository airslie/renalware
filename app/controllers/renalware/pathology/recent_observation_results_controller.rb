# frozen_string_literal: true

module Renalware
  module Pathology
    class RecentObservationResultsController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::Pageable

      def index
        authorize pathology_patient
        observations_table = CreateObservationsGroupedByDateTable.new(
          patient: pathology_patient,
          observation_descriptions: ObservationDescription.in_display_order,
          page: page || 1,
          per_page: per_page || 100
        ).call

        render :index, locals: { patient: pathology_patient, table: observations_table }
      end
    end
  end
end
