module Renalware
  module HD
    module Scheduling
      class ArchiveArguments
        attr_reader :from_week_period, :to_week_period, :up_until_date

        def initialize(from: nil, to: nil)
          @from_week_period = WeekPeriod.from_date(from || 1.year.ago)
          @up_until_date = (to || 1.day.ago).to_date
          @to_week_period = WeekPeriod.from_date(@up_until_date)
        end
      end
    end
  end
end
