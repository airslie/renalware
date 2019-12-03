# frozen_string_literal: true

require "rails_helper"

describe "Listing all events", type: :system do
  it "A user views a list of events for all patients" do
    login_as_clinical

    visit events_filtered_list_path(named_filter: :all)

    expect(page).to have_content("Events")
  end
end
