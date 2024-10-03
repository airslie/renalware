# frozen_string_literal: true

describe "Searching HD Slot Requests", js: true do
  include PatientsSpecHelper

  let(:location) { create(:hd_slot_request_location, name: "ABC") }
  let(:access_state) { create(:hd_slot_request_access_state) }

  before do
    location
    access_state
  end

  it "can filter by patient name" do
    user = login_as_admin
    patient = create(:hd_patient, by: user, family_name: "FamilyXxx", local_patient_id: "MRN1")
    create(:hd_slot_request,
           patient: patient,
           created_at: "2023-10-01 03:03:03",
           urgency: "highly_urgent",
           access_state: access_state,
           location: location)

    visit renalware.hd_slot_requests_path

    expect(page).to have_content("HD Slot Requests")

    expect(page).to have_content("FAMILYXXX")

    fill_in "Patient name/NHS/MRN", with: "Yyy"

    expect(page).to have_no_content("FAMILYXXX")
  end
end
