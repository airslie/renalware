module Renalware
  module Pathology
    # Responsible for finding the current observations for a patient for the
    # specified observation descriptions. It returns a result for each
    # observation description, nulls for missing observations for that
    # description.
    #
    # Note the query does not accept a relation as trying to compose it may break the
    # desired result set.
    #
    class CurrentObservationsForDescriptionsQuery
      def initialize(patient:, descriptions:)
        @patient = patient
        @descriptions = descriptions
      end

      # If no observations found, returns nil values for all descriptions, e.g.
      #   <ActiveRecord::Relation [
      #     #<Renalware::Pathology::Observation id: nil, ...(all nil)>,
      #     #<Renalware::Pathology::Observation id: nil, ...(all nil)>,
      #     ...
      #   ]
      # or if results found:
      # #<ActiveRecord::Relation [
      #   #<Renalware::Pathology::Observation id: 199, result: "48", observed_at: "2016-03-15..>,
      #   #<Renalware::Pathology::Observation id: 201, result: "71", observed_at: "2016-03-15..>,
      #   ...
      # ]
      def call
        # Note:
        #
        #   CurrentObservation.where(patient: patient, description_name: descriptions.map(&:name))
        #
        # is potentially a replacement for the SQL below, but it does not return
        # null values. We'd need a bit of SQL to join again onto pathology_observation_descriptions
        # and fill the missing observations with NULLs in order to keep the output of this query
        # the same.
        Observation
          .includes(:description)
          .select(<<-SQL.squish)
            DISTINCT ON (pathology_observation_descriptions.id)
            pathology_observations.*,
            pathology_observation_descriptions.code AS description_code,
            pathology_observation_descriptions.name AS description_name
          SQL
          .joins(<<-SQL.squish)
            LEFT JOIN pathology_observation_requests
            ON pathology_observations.request_id = pathology_observation_requests.id
          SQL
          .joins(<<-SQL.squish)
            RIGHT JOIN pathology_observation_descriptions
            ON pathology_observations.description_id = pathology_observation_descriptions.id
          SQL
          .order("pathology_observation_descriptions.id")
          .ordered
          .where(["pathology_observation_requests.patient_id = ? OR " \
                  "pathology_observation_requests.patient_id IS NULL", patient.id])
          .where(pathology_observation_descriptions: { id: descriptions })
      end

      private

      attr_reader :patient, :descriptions
    end
  end
end
