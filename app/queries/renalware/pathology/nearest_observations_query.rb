module Renalware
  module Pathology
    class NearestObservationsQuery
      pattr_initialize [:patient!, :date!, :code_group!, look_behind_days!: 2]

      def call
        pathology_patient
          .observations
          .joins(:description)
          .where(description_id: observation_description_ids)
          .where(observed_at: (date - look_behind_days.days).beginning_of_day..)
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

      private

      def pathology_patient
        Pathology.cast_patient(patient)
      end

      def observation_description_ids
        @observation_description_ids ||= code_group.memberships.pluck(:observation_description_id)
      end
    end
  end
end
