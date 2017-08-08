require "rails_helper"

feature "Listing patient events", type: :feature do

  scenario "A user views a list of patient events" do
    user = login_as_clinician
    patient = create(:patient, created_by: user, updated_by: user)

    visit patient_events_path(patient)

    expect(page).to have_content("Events")

    # TODO: check displayed, test filtering
  end
end
