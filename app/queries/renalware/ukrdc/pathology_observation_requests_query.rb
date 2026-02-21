module Renalware
  module UKRDC
    class PathologyObservationRequestsQuery
      pattr_initialize [:patient_id!, :changes_since!]

      def call
        observation_requests
      end

      private

      # rubocop:disable Rails/WhereRange
      def observation_requests
        Pathology::ObservationRequest
          .where(id: Pathology::ObservationRequest.distinct_for_patient_id(patient_id))
          .where("pathology_observation_requests.created_at >= ?", effective_changes_since)
          .where("loinc_code is not null") # NOTE: fails using where.not(loinc_code: nil)
          .eager_load(
            :description,
            observations: { description: :measurement_unit }
          )
          .order(observed_at: :asc)
      end
      # rubocop:enable Rails/WhereRange

      # If there is a pathology_start_date configured in an ENV var, use this
      # for fetching pathology. This allows us to send a one-off batch of patients
      # with historical pathology. Most of the time this setting is not present, and
      # default to using changes_since.
      def effective_changes_since
        configured_pathology_start_date || changes_since
      end

      def configured_pathology_start_date
        start_date = Renalware.config.ukrdc_pathology_start_date
        return if start_date.blank?

        Date.parse(start_date)
      end
    end
  end
end
