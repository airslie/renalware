# frozen_string_literal: true

describe "Create Duke Activity Status Index (DASI) event", :js do
  it "creates successfully" do
    user = login_as_clinical
    patient = create(:patient, family_name: "XXX", given_name: "Jon", by: user)

    create(:duke_activity_status_index_event_type)

    visit renalware.patient_clinical_profile_path(patient)

    within ".page-actions" do
      click_on "Add"
      click_on "DASI Score"
    end

    #
    # First use invalid inputs to test re-display of form and routing etc
    #
    fill_in "Score", with: "not a number"

    expect {
      click_on "Create"
    }.not_to change(Renalware::Events::Event, :count)

    expect(page).to have_content("is not a number")

    fill_in "Score", with: ""

    expect {
      click_on "Create"
    }.not_to change(Renalware::Events::Event, :count)

    expect(page).to have_content("can't be blank")

    #
    # Now add valid inputs
    #
    fill_in "Score", with: "23.45"

    expect {
      click_on "Create"
    }.to change(Renalware::Events::Event, :count).by(1)

    expect(page).to have_current_path(renalware.patient_events_path(patient))

    registration = Renalware::Events::Event.where(patient: patient).last
    expect(registration.document).to have_attributes(
      score: 23.45
    )
  end
end
