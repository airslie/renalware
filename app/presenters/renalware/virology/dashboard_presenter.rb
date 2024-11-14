# frozen_string_literal: true

module Renalware
  module Virology
    class DashboardPresenter
      include PresenterHelper

      attr_reader_initialize :patient

      def latest_hep_b_antibody_statuses
        @latest_hep_b_antibody_statuses ||= begin
          obx_code = Array(Renalware.config.pathology_hep_b_antibody_status_obx_code).compact_blank
          observation_descriptions = Renalware::Pathology::ObservationDescription.for(obx_code)
          Renalware::Pathology::CreateObservationsGroupedByDateTable.new(
            patient: patient,
            observation_descriptions: observation_descriptions,
            page: 1,
            per_page: 5
          ).call
        end
      end

      def latest_hep_b_antibody_statuses?
        latest_hep_b_antibody_statuses.rows.any?
      end

      def vaccinations
        CollectionPresenter.new(
          Vaccination
            .includes([:created_by, :event_type])
            .for_patient(patient)
            .order(date_time: :desc),
          Events::EventPresenter
        )
      end
    end
  end
end
