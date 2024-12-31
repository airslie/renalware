module Renalware
  module Pathology
    module Charts
      # Defines period abbreviations used in charts to select just data in that
      # period, e.g. 3y maps to a date 3 years ago which can be fed into a query
      class PeriodMap
        DEFAULT_PERIOD = -> { 100.years.ago }.freeze
        PERIODS = {
          "1m" => -> { 1.month.ago },
          "3m" => -> { 3.months.ago },
          "1y" => -> { 1.year.ago },
          "3y" => -> { 3.years.ago },
          "10y" => -> { 10.years.ago }
        }.freeze

        def self.[](period)
          PERIODS.fetch(period.to_s, DEFAULT_PERIOD).call.to_date.to_s
        end

        def self.periods
          PERIODS.keys
        end
      end
    end
  end
end
