module Renalware
  Rails.benchmark "Adding Sample Snippets" do
    x = User.count
    # For DNA snippets -- so not every user has one
    y = x / 2

    modals = %w(Nephrology Transplant HD PD Access)

    body_text_1 = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, " \
                  "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. " \
                  "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris " \
                  "nisi ut aliquip ex ea commodo consequat."

    body_text_2 = "Duis aute irure dolor in reprehenderit in voluptate " \
                  "velit esse cillum dolore eu fugiat nulla pariatur. " \
                  "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui " \
                  "officia deserunt mollit anim id est laborum."

    x.times do |i|
      clinic = modals.sample
      Renalware::Authoring::Snippet.create(
        author_id: i,
        title: "#{clinic} Clinic snippet",
        last_used_on: i.days.ago,
        times_used: i,
        body: "I saw this patient in #{clinic} Clinic today. #{body_text_1}"
      )
    end

    x.times do |i|
      mdm = modals.sample
      Renalware::Authoring::Snippet.create(
        author_id: i,
        title: "#{mdm} MDM snippet",
        last_used_on: i.days.ago,
        times_used: 1,
        body: body_text_2.to_s
      )
    end

    y.times do |i|
      clinic = modals.sample
      Renalware::Authoring::Snippet.create(
        author_id: i,
        title: "#{clinic} Clinic DNA",
        last_used_on: i.days.ago,
        times_used: 10,
        body: "This patient did not attend the #{clinic} Clinic ullamco " \
              "laboris nisi ut aliquip ex ea commodo consequat. " \
              "Duis aute irure dolor in reprehenderit in voluptate"
      )
    end
  end
end
