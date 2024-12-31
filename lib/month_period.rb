class MonthPeriod
  attr_reader :month, :year, :start, :finish

  def initialize(month:, year:)
    @month = month
    @year = year
    @start = Time.new(year, month, 1, 0, 0, 0)
    @finish = start.end_of_month.end_of_day
  end

  def to_range
    start..finish
  end
end
