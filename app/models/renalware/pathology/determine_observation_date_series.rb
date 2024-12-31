module Renalware
  module Pathology
    # Responsible for finding the series of unique `observed_at` dates for an
    # Observation relation.
    #
    class DetermineObservationDateSeries
      def initialize(relation: Observation)
        @relation = relation
      end

      # @return Array: e.g.
      # [
      #   Date.parse("2010-01-01"),
      #   Date.parse("2010-01-02"),
      #   Date.parse("2010-01-03")
      # ]
      #
      def call
        @relation
          .order("DATE(observed_at) DESC")
          .reselect("DISTINCT ON (DATE(observed_at)) DATE(observed_at) as date_observed_at")
          .map(&:date_observed_at)
      end
    end
  end
end
