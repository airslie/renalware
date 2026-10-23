module Renalware
  module Pathology
    # Wraps the query's daily aggregated results as rows with result and comment accessors.
    class ObservationsGroupedByDateTable
      attr_reader_initialize [:observation_descriptions!, :relation!]

      def rows
        @rows ||= relation.all.map(&:with_indifferent_access).map { |row| Row.new(row) }
      end

      # Each row wraps a PGResult (database row).
      # Each row is all the pathology results for this patient on a particular day.
      # Hence there is one observed_on date but multiple results which are the columns going across
      # the table.
      class Row
        pattr_initialize :row

        def observed_on       = Renalware::DateUtils.to_date(row[:observed_on])
        def observed_at       = observed_on
        def result_for(code)  = row_hash[code&.to_sym]&.first
        def comment_for(code) = row_hash[code&.to_sym]&.last

        # A hash keyed by OBX code, containing an array of [result, comment] arrays, e.g.
        #
        #  { "HGB": [[123,nil],[124,'Some comment about the result',[..]], "PLT": [..] }
        #
        # This is a compressed format (as opposed to returning more verbose json) to
        # improve performance. Just remember that for any result, its an array of [result, comment]
        def row_hash
          @row_hash = JSON.parse(row[:results]).with_indifferent_access
        end
      end
    end
  end
end
