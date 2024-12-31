module DateHelpers
  def todays_date
    l(Time.zone.today)
  end

  def todays_date_and_time
    l(Time.zone)
  end
end
