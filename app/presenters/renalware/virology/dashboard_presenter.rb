module Renalware
  module Virology
    class DashboardPresenter
      include PresenterHelper
      DEFAULT_OBX_CODE = "BHBS".freeze
      CODE_GROUP_NAME = "hep_b_antibody_statuses".freeze

      attr_reader_initialize :patient

      def latest_hep_b_antibody_statuses
        @latest_hep_b_antibody_statuses ||= begin
          Renalware::Pathology::CreateObservationsGroupedByDateTable.new(
            patient: patient,
            observation_descriptions: hep_b_antibody_statuses_observation_descriptions,
            page: 1,
            per_page: 5
          ).call
        end
      end

      def latest_hep_b_antibody_statuses? = latest_hep_b_antibody_statuses.rows.any?

      def vaccinations
        CollectionPresenter.new(
          Vaccination
            .includes([:created_by, :event_type])
            .for_patient(patient)
            .order(date_time: :desc),
          Events::EventPresenter
        )
      end

      private

      def hep_b_antibody_statuses_observation_descriptions
        Renalware::Pathology::ObservationDescription.for(hep_b_antibody_statuses_obx_codes)
      end

      def hep_b_antibody_statuses_obx_codes
        group = Pathology::CodeGroup.find_by(name: CODE_GROUP_NAME)
        return [DEFAULT_OBX_CODE] if group.blank?

        group.observation_descriptions.map(&:code)
      end
    end
  end
end
