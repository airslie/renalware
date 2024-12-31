module Renalware
  module Pathology
    class CreateObservationsGroupedByDateTable
      attr_reader :patient, :observation_descriptions, :options

      def initialize(patient:, observation_descriptions:, **options)
        @patient = patient
        @observation_descriptions = observation_descriptions
        @options = options
      end

      def call
        create_observations_table
      end

      private

      def fetch_grouped_observations
        ObservationsGroupedByDateQuery.new(
          patient: patient,
          observation_descriptions: observation_descriptions,
          **options
        )
      end

      def create_observations_table
        ObservationsGroupedByDateTable.new(
          relation: fetch_grouped_observations,
          observation_descriptions: observation_descriptions
        )
      end
    end
  end
end
