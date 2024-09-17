# frozen_string_literal: true

describe "Listing patient events" do
  it "A user views a list of patient events" do
    user = login_as_clinical
    patient = create(:patient, by: user)

    visit patient_events_path(patient)

    expect(page).to have_content("Events")

    # TODO: check displayed, test filtering
  end
end
