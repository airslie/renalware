# Mix this module into a Patient Query object for example in order to include the patient's
# current key pathology and enable sorting on pathology date and value fields using
# ransack's sort_link helper in the view.
#
module Renalware
  module PatientPathologyScopes
    extend ActiveSupport::Concern
    RANSACKABLE_OBX_CODES = %i(hgb ure cre urr phos pthi pot).freeze

    # Define some ransackers to make it easier to sort the table (using sort_link)
    # on pathology dates and values. Note it wasn't possible just to use say
    # = sort_link(.., "pathology_current_key_observation_sets.cre_observed_at", ..)
    # or
    # = sort_link(.., :pathology_current_key_observation_set_cre_observed_at", ..)
    # as ransack wasn't happy and discarded the sort predicate.
    # So here we mix in useful ransackers as short cut to use in sort_link
    #
    # Example usage:
    #   = sort_link(<url>, :cre_date, "CRE date")
    #
    included do
      RANSACKABLE_OBX_CODES.each do |code|
        ransacker(code) { pathology_result_sort_predicate(code) }
        ransacker(:"#{code}_date") { pathology_date_sort_predicate(code) }
      end

      %i(egfr).each do |code|
        ransacker(code) { pathology_result_sort_predicate(code) }
      end
    end

    class_methods do
      def with_current_pathology
        includes(:current_observation_set)
      end

      # Make sure we whitelist the ransackers defined above
      def ransackable_attributes(*) = super + _ransackers.keys

      # Note that because #result could have text like "Test Cancelled" in it, we need to
      # handle that when sorting, and we do that by calling a custom sql function which returns
      # 0 if casting to a float fails. Null results to we map to a 0.
      # This way results appear in this order:
      # 1. Valid floats e.g. 10.4
      # 2. Results with a message like Test Cancelled (mapped to 0) - more significant than a null
      #   so should rise above them when sorted
      # 3. Nulls (mapped to -1)
      def pathology_result_sort_predicate(column)
        sanitized_column = Arel.sql(sanitize(column.to_s.upcase))
        Arel.sql(
          "coalesce(convert_to_float(values -> #{sanitized_column} ->> 'result'), -1)"
        )
      end

      def pathology_date_sort_predicate(column)
        sanitized_column = Arel.sql(sanitize(column.to_s.upcase))
        Arel.sql(
          "cast(values -> #{sanitized_column} ->> 'observed_at' as date)"
        )
      end

      def sanitize(sql)
        ActiveRecord::Base.connection.quote(sql)
      end
    end
  end
end
