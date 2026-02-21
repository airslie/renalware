module Renalware
  module Pathology
    # Responsible for finding the most recent observations results with in
    # the specified date range.
    #
    class ObservationsWithinDateRangeQuery
      def initialize(date_range:, relation: Observation.all)
        @relation = relation
        @date_range = date_range
      end

      def call
        @relation.where(observed_at: @date_range)
      end
    end
  end
end
