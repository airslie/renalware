require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Drug Frequencies" do
    [
      ["once_daily", "Once daily", 7],
      ["every_other_day", "Every other day", 3.5],
      ["mon_wed_fri", "Mondays, Wednesdays and Fridays", 3],
      ["tue_thu_sat", "Tuesday, Thursdays and Saturdays", 3],
      ["with_meals", "With meals (main meals)", 21],
      ["2_times_daily", "Twice daily", 14],
      ["3_times_daily", "Three times a day", 21],
      ["4_times_daily", "Four times a day", 28],
      ["5_times_daily", "Five times a day", 35],
      ["daily_at_night", "At night", 7],
      ["daily_each_morning", "In the morning", 7],
      ["2_times_weekly", "Twice each week", 2],
      ["3_times_weekly", "Three times a week", 3],
      ["weekly", "Once a week", 1],
      ["every_2_weeks", "Every two weeks", 0.5],
      ["every_3_weeks", "Every three weeks", 0.33],
      ["every_4_weeks", "Every four weeks", 0.25],
      ["every_month", "Once a month", 0.25],
      ["every_3_months", "Every three months", 0.08],
      ["every_6_months", "Every six months", 0.04],
      ["as_required", "As required", nil],
      ["once_only", "Once only (stat)", nil]
    ].each_with_index do |(name, title, doses_per_week), idx|
      Drugs::Frequency.find_or_create_by!(
        name: name,
        title: title,
        doses_per_week: doses_per_week,
        position: idx
      )
    end
  end
end
