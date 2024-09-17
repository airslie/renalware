# frozen_string_literal: true

require "week_period"

module Renalware::HD::Scheduling
  describe ArchiveArguments do
    describe "#from_week_period" do
      context "when no from: argument supplied in the initializer" do
        it "returns a WeekPeriod that defaults to 1 year ago" do
          travel_to Time.zone.parse("2019-01-01 12:00:00") do
            week_period = described_class.new.from_week_period

            expect(week_period.year).to eq(2018)
            expect(week_period.week_number).to eq(1) # first week of the year
          end
        end
      end

      context "when from: argument is supplied in the initializer" do
        it "returns the correct WeekPeriod" do
          travel_to Time.zone.parse("2019-01-01 12:00:00") do
            week_period = described_class.new(from: 6.months.ago).from_week_period

            expect(week_period.year).to eq(2018)
            expect(week_period.week_number).to eq(26)
          end
        end
      end
    end

    describe "#to_week_period" do
      context "when no to: argument supplied in the initializer" do
        it "returns a default WeekPeriod representing *yesterday*" do
          travel_to Time.zone.parse("2019-01-01 12:00:00") do
            week_period = described_class.new.to_week_period

            # Note that although yesterday in this case means going back into last year
            # its is still the same calender week and calender year as today because
            # 2019-01-01 was a Tuesday so yesterday is a Monday, so in the same week (week 1)
            # and the same 'calendar year' of 2019
            expect(week_period.year).to eq(2019)
            expect(week_period.week_number).to eq(1) # first week of the year
          end
        end
      end

      context "when a to: argument supplied in the initializer" do
        it "returns a WeekPeriod for that date" do
          week_period = described_class.new(to: Time.zone.parse("2019-03-03")).to_week_period

          expect(week_period.year).to eq(2019)
          expect(week_period.week_number).to eq(9)
        end
      end
    end

    describe "#up_until" do
      context "when no to: arg is supplied" do
        it "returns yesterday's date" do
          travel_to Time.zone.parse("2019-01-01 12:00:00") do
            date = described_class.new.up_until_date

            expect(date).to be_a(Date)
            expect(date).to eq(1.day.ago.to_date)
          end
        end
      end

      context "when a to: arg is supplied" do
        it "returns that date" do
          travel_to Time.zone.parse("2019-01-01 12:00:00") do
            date = described_class.new(to: Date.current).up_until_date

            expect(date).to eq(Date.current)
          end
        end
      end
    end
  end
end
