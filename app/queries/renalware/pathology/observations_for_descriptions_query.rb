# Responsible for finding Observations for the specified descriptions.
module Renalware
  module Pathology
    class ObservationsForDescriptionsQuery
      def initialize(relation: Observation.all, descriptions: ObservationDescription.all)
        @relation = relation
        @descriptions = descriptions
      end

      def call
        @relation
          .joins(:description)
          .preload(:description)
          .where(description: @descriptions)
      end
    end
  end
end
