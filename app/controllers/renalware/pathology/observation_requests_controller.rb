module Renalware
  module Pathology
    class ObservationRequestsController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::PatientCasting
      include Pagy::Backend

      def index
        authorize pathology_patient
        query = find_observation_requests
        pagy, observation_requests = pagy(query.result)
        render locals: {
          observation_requests: observation_requests,
          search: query,
          obr_filter_options: obr_filter_options,
          patient: pathology_patient,
          pagy: pagy
        }
      end

      def show
        authorize pathology_patient
        observation_request = find_observation_request

        render locals: { observation_request: observation_request, patient: pathology_patient }
      end

      private

      # Select just the OBR description ids and codes that have been associated with this patient.
      # We'll uses them to build a filter dropdown list.
      def obr_filter_options
        pathology_patient
          .observation_requests
          .joins(:description)
          .order("pathology_request_descriptions.code asc")
          .pluck(
            Arel.sql(
              "distinct on(pathology_request_descriptions.code) pathology_request_descriptions.code"
            ),
            "pathology_request_descriptions.id",
            "pathology_request_descriptions.name"
          )
      end

      def find_observation_requests
        pathology_patient
          .observation_requests
          .includes(:description)
          .ordered
          .ransack(params[:q])
      end

      def find_observation_request
        pathology_patient
          .observation_requests
          .includes(observations: :description)
          .find(params[:id])
      end
    end
  end
end
