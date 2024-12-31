require "week_period"

module Renalware
  module HD
    module Scheduling
      # Represents a range of WeekPeriods and their diaries for a hospital unit
      class DiaryRange
        pattr_initialize [:from_week_period!, :to_week_period!, :unit!]

        # If there are any missing weekly diaries in the date range, create them
        def create_missing_weekly_diaries(by:)
          week_periods_in_range.each do |period|
            WeeklyDiary.find_or_create_by!(
              hospital_unit_id: unit.id,
              week_number: period.week_number,
              year: period.year
            ) do |diary|
              log_weekly_diary_creation(period)
              diary.master_diary = master_diary_for(unit, by)
              diary.by = by
            end
          end
        end

        def log_weekly_diary_creation(period)
          Rails.logger.debug {
            "DEBUG: Creating weekly diary for unit #{unit.id} period " \
              "#{period.week_number}/#{period.year}"
          }
        end

        def from_date
          from_week_period.date_on_first_day_of_week
        end

        def to_date
          to_week_period.date_on_first_day_of_week
        end

        private

        # Returns an array of WeekPeriods for each cwyear and cweek in the date range.
        def week_periods_in_range
          @week_periods_in_range ||= begin
            # The array in the uniq block here serves to filter the date range. It filters out
            # just the dates representing the first day of each unique week/year.
            mondays_in_date_range = (from_date..to_date).uniq { |dt| [dt.cwyear, dt.cweek] }
            # Now map the dates (one per week) into WeekPeriods
            mondays_in_date_range.map do |date|
              WeekPeriod.new(week_number: date.cweek, year: date.cwyear)
            end
          end
        end

        def master_diary_for(unit, by)
          MasterDiary.find_or_create_by!(hospital_unit_id: unit.id) do |diary|
            Rails.logger.debug { "DEBUG: Creating master diary for unit #{unit.id}" }
            diary.master = true
            diary.by = by
          end
        end
      end
    end
  end
end
