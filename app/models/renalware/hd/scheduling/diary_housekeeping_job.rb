# A cron job creates this delayed job, which does the following:
# For all Weekly Diaries in the past, plus this week
# for each day that is in the past
# mark any slots in the weekly diary as archived
# and where the weekly diary is inheriting slots from the master diary
# create corresponding slots in the weekly diary (ie migrate those slots from master to weekly)
# and archive them.
# No slots before the current day should be touched
module Renalware
  module HD
    module Scheduling
      class DiaryHousekeepingJob < ApplicationJob
        queue_as :hd_diary_housekeeping

        # :reek:UtilityFunction
        def perform
          up_until ||= Time.zone.today - 1.day
          up_until = up_until.to_date
          create_missing_weekly_diaries
          move_elapsed_master_slots_into_weekly_slot_equivalent
          archive_old_weekly_slots(up_until)
        end

        private

        # Just inc case there are some missing weekly diaries
        def create_missing_weekly_diaries
          args = ArchiveArguments.new
          Hospitals::Unit.hd_sites.each do |unit|
            DiaryRange.new(
              from_week_period: args.from_week_period,
              to_week_period: args.to_week_period,
              unit: unit
            ).create_missing_weekly_diaries(by: User.first)
          end
        end

        # Copy any master slots that are now in the past (as of midnight Sunday just gone) and
        # which do not already have a weekly slot overriding the master, into weekly slots.
        # This is to stop changes to the master diary affecting diary history.
        # This executes a SQL view to do the dirty work. It references a SQL view called
        # hd_diary_matrix to help it to decide which master slots to copy to the weekly diary.
        # That view could be useful for other things. We could in fact build the diary UI from it.
        def move_elapsed_master_slots_into_weekly_slot_equivalent
          Rails.logger.debug("DEBUG: SELECT renalware.hd_diary_archive_elapsed_master_slots()")
          conn = ActiveRecord::Base.connection
          conn.execute("SELECT renalware.hd_diary_archive_elapsed_master_slots()")
        end

        # Flag elapsed slots as archived. Principally this will help us to stop them from being
        # changed.
        def archive_old_weekly_slots(up_until)
          slots = DiarySlot
            .unarchived
            .joins(:diary)
            .where(hd_diaries: { year: up_until.year, week_number: up_until.cweek })
            .where(day_of_week: up_until.cwday)

          ids = slots.pluck(:id)
          Rails.logger.info("Archiving #{ids.length} slots up_until #{up_until} with ids #{ids}")
          slots.update_all(archived: true, archived_at: Time.zone.now)
        end
      end
    end
  end
end
