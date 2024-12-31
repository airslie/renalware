module Renalware
  module HD
    class PatientsWithUnmetPreferencesQuery
      def initialize(query = {})
        @query = query
      end

      def call
        search.result
      end

      def search
        HD::Patient
          .extend(Scopes)
          .includes(hd_profile: :hospital_unit)
          .includes(hd_preference_set: :hospital_unit)
          .eager_load(:hd_profile)
          .eager_load(:hd_preference_set)
          .having_an_unmet_preference
          .ransack(query)
      end

      private

      attr_reader :query

      module Scopes
        def having_an_unmet_preference
          sql = <<-SQL.squish
            (hd_preference_sets.hospital_unit_id > 0 AND
              hd_profiles.hospital_unit_id != hd_preference_sets.hospital_unit_id) OR
            (coalesce(hd_preference_sets.schedule_definition_id, 0) != 0 AND
              hd_profiles.schedule_definition_id != hd_preference_sets.schedule_definition_id) OR
            (coalesce(hd_preference_sets.other_schedule, '') != '' AND
              hd_profiles.other_schedule != hd_preference_sets.other_schedule)
          SQL
          where(sql)
        end
      end
    end
  end
end
