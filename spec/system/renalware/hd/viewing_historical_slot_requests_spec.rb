# frozen_string_literal: true

describe "Managing a list of HD Slot Requests" do
  include PatientsSpecHelper

  let(:location) { create(:hd_slot_request_location) }
  let(:access_state) { create(:hd_slot_request_access_state) }

  it "lists allocated slot requests" do
    user = login_as_admin
    patient = create(:hd_patient, by: user, local_patient_id: "MRN1")

    create(:hd_slot_request,
           patient: patient,
           created_at: "2023-10-01 03:03:03",
           allocated_at: "2023-10-01 03:03:04",
           urgency: "highly_urgent",
           access_state: access_state,
           location: location)

    visit renalware.historical_hd_slot_requests_path

    expect(page).to have_content("HD Slot Requests")
    expect(page).to have_content("Historical")

    within("table#slot-requests") do
      expect(page).to have_content("01-Oct-2023")
      expect(page).to have_content(patient.to_s)
      expect(page).to have_content(patient.local_patient_id)
      expect(page).to have_content("Highly urgent")
    end
  end

  it "lists deleted slot requests" do
    user = login_as_admin
    patient = create(:hd_patient, by: user, local_patient_id: "MRN1")
    create(:hd_slot_request,
           patient: patient,
           created_at: "2023-10-01 03:03:03",
           deleted_at: "2023-10-01 03:03:04",
           deletion_reason: create(:hd_slot_request_deletion_reason, reason: "Something"),
           urgency: "highly_urgent",
           access_state: access_state,
           location: location)

    visit renalware.historical_hd_slot_requests_path

    within("table#slot-requests") do
      expect(page).to have_content("01-Oct-2023")
      expect(page).to have_content("Something")
    end
  end

  it "does not display requests that are neither deleted or allocated" do
    user = login_as_admin
    patient = create(:hd_patient, by: user, local_patient_id: "MRN1")
    create(:hd_slot_request,
           patient: patient,
           urgency: "highly_urgent",
           access_state: access_state,
           location: location)

    visit renalware.historical_hd_slot_requests_path

    within("table#slot-requests") do
      expect(page).to have_no_content(patient.to_s)
    end
  end
end
