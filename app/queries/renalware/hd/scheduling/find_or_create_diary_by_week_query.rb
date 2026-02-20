require "week_period"
##
# Returns a hospital unit's diary for the requested week (passed to #new as a WeekPeriod
# value object).
#
module Renalware
  module HD
    module Scheduling
      class FindOrCreateDiaryByWeekQuery
        attr_reader :unit_id, :period, :by, :relation

        def initialize(unit_id:, week_period:, by:, relation: WeeklyDiary.all)
          @relation = relation
          @period = week_period
          @unit_id = unit_id
          @by = by
        end

        def call
          find_or_create_diary
        end

        private

        # Find the diary for the current unit/week/year, or, if for example if a user wants to fill
        # next week's diary and it does not yet exist, create it
        # NB we _always_ return a diary from this method - whether it is found or built just-in-time
        def find_or_create_diary
          attrs = {
            hospital_unit_id: unit_id,
            week_number: period.week_number,
            year: period.year,
            master: false
          }
          relation.find_by(**attrs) || build_diary(**attrs)
        end

        # Create a new Weekly diary for the current week/year/unit
        # Add in DiaryPeriods for each currently defined diurnal period eg am pm eve
        def build_diary(attrs)
          master_diary = FindOrCreateMasterDiary.for_unit(unit_id, by)
          diary = WeeklyDiary.create!(**attrs, by: by, master_diary: master_diary)
          # Reload the diary using the supplied relation (might be eager_loads etc)
          relation.find(diary.id)
        end
      end
    end
  end
end
