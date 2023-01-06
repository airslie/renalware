# frozen_string_literal: true

module Renalware
  module Reporting
    class FetchAuditJson
      class << self
        def call(view_name)
          convert_rows_from_audit_view_into_datatables_compatible_json(view_name)
        end

        def convert_rows_from_audit_view_into_datatables_compatible_json(view_name)
          conn = ActiveRecord::Base.connection
          result = conn.execute("select audit_view_as_json(#{conn.quote(view_name)});")
          result.values[0][0]
        end
      end

      # A WIP to translate audit column names into human friendly ones.
      # May need to establish guidelines for instance apply text case in the view itself so
      # eg pct_HGB = % HGB without having to know to upcase certain bits of the name but
      # capitalise others etc.
      # def self.humanize_column_name(column)
      #   column
      #     .gsub("pct_", "% ")
      #     .gsub("count_", "No.")
      #     .gsub("avg_", "Avg ")
      #     .gsub("max", "Max ")
      #     .gsub("gt_eq_", "≥ ")
      #     .gsub("lt_eq_", "≤ ")
      #     .gsub("gt_", "> ")
      #     .gsub("lt_", "< ")
      # end
    end
  end
end
