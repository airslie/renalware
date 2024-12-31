# Backed by a view - see
module Renalware
  module Pathology
    class ObservationsGroupedByDate < ApplicationRecord
      self.table_name = :pathology_observations_grouped_by_date

      def comment_for(code)
        results[code]&.last
      end

      def result_for(code)
        results[code]&.first
      end
    end
  end
end
