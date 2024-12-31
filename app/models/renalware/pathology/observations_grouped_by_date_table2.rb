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
    class ObservationsGroupedByDateTable2
      attr_reader_initialize [:observation_descriptions!, :relation!, :pagy]
      delegate :current_page, :total_pages, :limit_value, to: :relation

      def rows
        relation.all
      end
    end
  end
end
