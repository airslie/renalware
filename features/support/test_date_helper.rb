# A simple collection of dates so we don't have to make these up every time
# and protects us from changes in date/time UI implementation; i.e. selecting
# a different Calendar widget.
#
module TestDateHelper
  def fill_in_date_time(label, with:)
    fill_in(label, with: with)
  end

  def fake_date
    Date.parse("20-07-#{Date.current.year}")
  end

  def fake_time
    "10:45"
  end

  def fake_date_time
    "#{fake_date} #{fake_time}"
  end
end
World(TestDateHelper)
