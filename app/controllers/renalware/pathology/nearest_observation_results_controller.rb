module Renalware
  module Pathology
    class NearestObservationResultsController < BaseController
      def index
        near_date
        authorize Patient, :index?
        render json: nearest_results
      end

      private

      def code_group
        @code_group ||= CodeGroup.find(params[:code_group_id])
      end

      def observation_description_ids
        @observation_description_ids ||= code_group.memberships.pluck(:observation_description_id)
      end

      def near_date
        Date.parse(params[:date])
      end

      def nearest_results
        Pathology
          .cast_patient(Patient.find(params[:patient_id]))
          .observations
          .joins(:description)
          .where(description_id: observation_description_ids)
          .select(
            :observed_at,
            :result,
            :description_id,
            "pathology_observation_descriptions.code as code"
          )
          .map do |row|
            {
              code: row.code,
              observed_on: row.observed_at.to_date,
              result: row.result
            }
          end
      end
    end
  end
end
