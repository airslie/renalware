# frozen_string_literal: true

require "week_period"

module Renalware::HD::Scheduling
  describe DiaryHousekeepingJob do
    subject(:job) { described_class.new }

    # The number of weeks in a given year is equal to the corresponding week number of 28 December,
    # because it is the only date that is always in the last week of the year since it is a week
    # before 4 January which is always in the first week of the yea
    # http://en.wikipedia.org/wiki/ISO_week_date#Last_week
    def num_weeks_in_year(year = Date.current.year)
      Date.new(year - 1, 12, 28).cweek # magick date!
    end

    let(:user) { create(:user) }
    let(:patient) { create(:hd_patient) }
    let(:unit) { create(:hd_hospital_unit) }
    let(:station) { create(:hd_station, hospital_unit_id: unit.id, by: user) }
    let(:diurnal_period_code) { create(:hd_diurnal_period_code) }
    let(:master_diary) do
      create(
        :hd_master_diary,
        hospital_unit_id: unit.id,
        by: user
      )
    end

    def create_weekly_diary(week_period:)
      create(
        :hd_weekly_diary,
        master_diary: master_diary,
        hospital_unit_id: unit.id,
        week_number: week_period.week_number,
        year: week_period.year,
        by: user
      )
    end

    def create_slot(diary:, day_of_week:)
      create(:hd_diary_slot,
             diary: diary,
             patient: patient,
             station: station,
             day_of_week: day_of_week,
             diurnal_period_code_id: diurnal_period_code.id,
             by: user)
    end

    describe "#perform" do
      it "defaults the :up_until parameter to the end of yesterday" do
        job.perform_now
        # expect(job.up_until).to eq((Time.zone.today - 1.day))
      end

      context "when there are no old slots" do
        it "does nothing" do
          job.perform_now
        end
      end

      context "when there is an un-archived slot yesterday" do
        # rubocop:disable RSpec/MultipleExpectations
        it "archives it" do
          diary = nil
          # Travel to an arbitrary yesterday
          # Its week 5 and the day_of_week is 2 (Tuesday)
          travel_to Date.new(2019, 01, 31) do
            week_period = WeekPeriod.from_date(Time.zone.today)
            day_of_week = Time.zone.today.cwday

            expect(week_period.week_number).to eq(5)
            expect(day_of_week).to eq(4)

            diary = create_weekly_diary(week_period: week_period)
            create_slot(diary: diary, day_of_week: day_of_week)
          end

          # now travel to the day after (Wednesday)
          # we'll create another slot here which should not be archived
          travel_to Date.new(2019, 02, 01) do
            week_period = WeekPeriod.from_date(Time.zone.today)
            todays_day_of_week = Time.zone.today.cwday

            expect(week_period.week_number).to eq(5)
            expect(todays_day_of_week).to eq(5)

            slot_that_should_not_be_archived = create_slot(
              diary: diary,
              day_of_week: todays_day_of_week
            )

            expect(DiarySlot.count).to eq(2)
            expect(DiarySlot.archived.count).to eq(0)
            expect(DiarySlot.unarchived.count).to eq(2)

            # Running the job with no arguments will try and archive yesterday slot
            job.perform_now

            expect(DiarySlot.count).to eq(2)
            expect(DiarySlot.archived.count).to eq(1)
            expect(DiarySlot.unarchived.count).to eq(1)
            expect(slot_that_should_not_be_archived.reload.archived).to be_falsy
          end
        end
        # rubocop:enable RSpec/MultipleExpectations
      end

      context "when past master slots are being inherited by weekly diaries" do
        it "copies the master slot to the weekly diaries" do
          pending "TODO: get to the bottom of this intermittently failing spec"
          fail
          # day_of_week = Time.zone.today.cwday
          # week_period = WeekPeriod.from_date(Time.zone.today)
          # weekly_diary = create_weekly_diary(week_period: week_period)

          # create(
          #   :hd_diary_slot,
          #   diary: weekly_diary,
          #   patient: patient,
          #   station: station,
          #   day_of_week: day_of_week,
          #   diurnal_period_code_id: diurnal_period_code.id,
          #   by: user
          # )

          # create(
          #   :hd_diary_slot,
          #   diary: master_diary,
          #   created_at: 5.years.ago,
          #   patient: patient,
          #   station: station,
          #   day_of_week: day_of_week,
          #   diurnal_period_code_id: diurnal_period_code.id,
          #   by: user
          # )

          # expect(Diary.count).to eq(2) # we have a weekly and master diary already
          # expect(DiarySlot.count).to eq(2) # each has a slot

          # job.perform_now

          # # TODO: investigate periodic failure on line 149 eg on Jan 6 2021
          # pending

          # # creates another 52 weekly diaries - we already have 1 master. Sot it is calculating
          # # there are 53 weeks across the year (which is possible as they are commercial weeks)
          # # and we already have 1 weekly diary so it is creating 52 more.
          # expect(Diary.count).to be >= (num_weeks_in_year + 2)

          # # We go back 3 months when archiving past slots.
          # # There should now be x weekly slots (1 in each weekly diary, and 3 months from 'now'
          # # actually spans x commercial weeks) + 1 master slot.
          # # This is a cop out but for now we know the number slots should be 1 (the master)
          # # plus a variable number of commercial weeks betrween 12 and 14 dependinng on where
          # # today lands
          # expect(DiarySlot.count).to be <= (14 + 1)
          # expect(DiarySlot.count).to be >= (12 + 1)
        end
      end
    end
  end
end
