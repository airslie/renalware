class WeekPeriod
  attr_reader :year,
              :week_number,
              :date_on_first_day_of_week,
              :last_day_of_week # The date of last day of the week (a Sunday)

  def self.from_date(date)
    date = date.to_date
    new(week_number: date.cweek, year: date.cwyear)
  end

  def initialize(week_number:, year:)
    @week_number = week_number.to_i
    @year = year.to_i
    validate_week_number
    validate_year
    @date_on_first_day_of_week = Date.commercial(@year, @week_number)
    @last_day_of_week ||= (@date_on_first_day_of_week + 1.week - 1.minute).to_date
  end

  def next
    self.class.from_date(date_on_first_day_of_week + 1.week)
  end

  def previous
    self.class.from_date(date_on_first_day_of_week - 1.week)
  end

  def to_a
    [week_number, year]
  end

  def to_s
    "#{I18n.l(date_on_first_day_of_week, format: :long)} " \
      "to #{I18n.l(last_day_of_week, format: :long)}"
  end

  def validate_week_number
    if week_number < 1 || week_number > 53
      raise(ArgumentError, "invalid date: week_number must be 1-53")
    end
  end

  def validate_year
    raise(ArgumentError, "invalid date year must be >= 2000") if year <= 2000
  end

  def to_h
    {
      year: year,
      week_number: week_number
    }
  end
end
