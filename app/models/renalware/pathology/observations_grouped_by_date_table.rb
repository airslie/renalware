require_dependency "renalware/pathology"
require "attr_extras"

module Renalware
  module Pathology
    # A helper class wrapping a custom relation object which has aggregated a
    # patient's pathology results by date of observation using raw SQL + PGResult.
    # Note we implement the required interface for kaminari pagination (we delegate to the
    # underlying relation to achieve this).
    #
    # This class exists to make the underlying PGResult set (wrapped in a custom relation-like
    # object) easier to consume.
    #
    # Example usage:
    # (ruby)
    # codes = %i(HGB PLT WBC)
    # rows = ObservationsGroupedByDateQuery.new(patient_id: 1, codes: codes)
    # table = ObservationsGroupedByDateTable.new(rows: rows, codes: %i(HGB PLT WBC))
    # (html)
    # table
    #   tr
    #     td Date
    #     - table.codes do |code|
    #       td= code
    #   tbody
    #     tr
    #       - table.each_row do |row|
    #         td= l(row.observed_on)
    #         - table.codes.each do |code|
    #           td= row.result_for(code)
    #
    # = paginate(table)
    #
    class ObservationsGroupedByDateTable
      attr_reader_initialize [:observation_descriptions!, :relation!]
      delegate :current_page, :total_pages, :limit_value, to: :relation

      def rows
        @rows ||= relation.all.map(&:with_indifferent_access).map { |row| Row.new(row) }
      end

      class Row
        pattr_initialize :row

        def observed_on
          Date.parse(row[:observed_on])
        end

        def result_for(code)
          results[code&.to_sym]
        end

        def results
          @results = JSON.parse(row[:results]).with_indifferent_access
        end
      end
    end
  end
end
