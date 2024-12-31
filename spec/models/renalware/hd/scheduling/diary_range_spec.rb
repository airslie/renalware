require "week_period"

module Renalware
  module HD
    describe Scheduling::DiaryRange do
      describe "#create_missing_weekly_diaries_for(unit)" do
        let(:user) { create(:user) }
        let(:unit) { create(:hd_hospital_unit) }

        context "when there are no diaries at all in the past year" do
          it "creates a diary for each week in the last year and one for this week, " \
             "plus a master diary for the unit" do
            travel_to Time.zone.parse("2019-01-01 12:00:00") do
              range = described_class.new(
                from_week_period: WeekPeriod.from_date(1.year.ago),
                to_week_period: WeekPeriod.from_date(1.day.ago),
                unit: unit
              )

              expect(Scheduling::WeeklyDiary.count).to eq(0)
              range.create_missing_weekly_diaries(by: user)
              expect(Scheduling::WeeklyDiary.count).to eq(53)
              expect(Scheduling::MasterDiary.count).to eq(1)
            end
          end
        end

        context "when there is one missing weekly diary in the missing period" do
          it "creates it" do
            create_weekly_diaries(week_numbers: [1, 2, 4], year: 2019) # week 3 is missing

            # Sanity check!
            expect(Scheduling::WeeklyDiary.count).to eq(3)
            expect(Scheduling::MasterDiary.count).to eq(1)

            travel_to Time.zone.parse("2019-01-29") do
              expect(Date.current.cweek).to eq(5) # a Tuesday in week 5

              range = described_class.new(
                from_week_period: WeekPeriod.from_date(4.weeks.ago),
                to_week_period: WeekPeriod.from_date(1.day.ago), # Monday, week 5
                unit: unit
              )

              range.create_missing_weekly_diaries(by: user)

              # From 4 weeks ago, so this week plus 4 in the past == 5
              expect(Scheduling::WeeklyDiary.count).to eq(5)
              expect(Scheduling::MasterDiary.count).to eq(1) # unchanged

              # Double-check the missing weekly diary was created
              expect(
                Scheduling::WeeklyDiary.exists?(
                  week_number: 3,
                  year: 2019,
                  hospital_unit_id: unit.id
                )
              ).to be(true)
            end
          end

          def create_weekly_diaries(week_numbers:, year:)
            Array(week_numbers).each do |cweek|
              Scheduling::WeeklyDiary.create!(
                hospital_unit_id: unit.id,
                year: year,
                week_number: cweek,
                created_by_id: user.id,
                updated_by_id: user.id,
                master_diary: create_master_diary
              )
            end
          end

          # For some reason the hd_master_diary is not letting us create one so for now doing
          # it commando
          def create_master_diary
            Scheduling::MasterDiary.find_or_create_by!(
              hospital_unit_id: unit.id,
              created_by_id: user.id,
              updated_by_id: user.id
            )
          end
        end
      end
    end
  end
end
