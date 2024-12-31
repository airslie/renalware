module Renalware
  Rails.benchmark "Adding Sample System Messages" do
    return if System::Message.count > 0

    # An active message - it will displayed on the login page
    System::Message.create!(
      title: "Scheduled Maintenance",
      body: "<div>Please be aware the system will be down between 1pm and 3pm on Sunday " \
            "for maintenance.</div>",
      severity: :default,
      display_from: 2.days.ago,
      display_until: 1.day.ago
    )
    # An inactive message - not displayed as finished in the past
    System::Message.create!(
      title: "HD Session Reminder",
      body: "<div>Please remember to sign-off any outstanding HD sessions before the " \
            "end of the month.</div>",
      severity: :info,
      display_from: 10.days.ago,
      display_until: 3.days.ago
    )
  end
end
