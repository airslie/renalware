module Renalware
  module Pathology
    class ObservationsController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::Pageable

      # Observation history for a particular OBX.
      # - HTML version is rendered from patient pathology under Investigations when you
      # select a Request and see its Observations and click on the Code.
      # - JSON version used in graphs
      def index
        authorize pathology_patient
        description = find_description
        observations = find_observations_for_description(description)

        respond_to do |format|
          format.html do
            render locals: {
              patient: pathology_patient,
              observations: observations,
              description: description
            }
          end
          format.json do
            render json: {
              code: description.code,
              name: description.name,
              results: observations.pluck(:observed_at, :result).map { |arr|
                [arr.first.to_date, arr.last&.to_f]
              }
            }
          end
        end
      end

      private

      def find_description
        ObservationDescription.find(params[:description_id])
      end

      def find_observations_for_description(description)
        pathology_patient
          .observations
          .page(page)
          .includes(:request)
          .for_description(description)
          .ordered
      end
    end
  end
end
