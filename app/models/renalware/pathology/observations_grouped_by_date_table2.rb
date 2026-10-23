module Renalware
  module Pathology
    # Wraps records from ObservationsGroupedByDate, with pagination exposed through pagy.
    class ObservationsGroupedByDateTable2
      attr_reader_initialize [:observation_descriptions!, :relation!, :pagy]

      def rows
        relation.all
      end
    end
  end
end
