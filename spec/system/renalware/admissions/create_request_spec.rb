# frozen_string_literal: true

describe "Create an Admission Request", js: true do
  it "Creating a new request from the patient LH menu" do
    user = login_as_clinical
    patient = create(:patient, by: user)
    reason = create(:admissions_request_reason, description: "AKI")
    unit = create(:hospital_unit, name: "Unit1")
    expect(Renalware::Admissions::Request.count).to eq(0)
    clinical_profile_path = patient_clinical_profile_path(patient)
    dialog_title = "Request Admission"

    visit clinical_profile_path

    within ".side-nav" do
      click_on "Request admission"
    end

    # We have just raised a modal, but are on the same page
    expect(page).to have_current_path(clinical_profile_path)

    expect(page).to have_content(dialog_title)

    # 1. Try filling out without a reason and we should get an error displayed in the dialog
    click_on("Create")
    expect(page).to have_content("can't be blank")

    # 2. Now submit valid data and we should be able to submit
    select reason.description, from: "Reason"
    select unit.name, from: "Current location"
    select "Medium", from: "Priority"
    fill_in "Notes", with: "Some notes"
    click_on("Create")

    expect(page).to have_no_content(dialog_title)
    requests = Renalware::Admissions::Request.all
    expect(requests.length).to eq(1)
    request = requests.first
    expect(request.reason_id).to eq(reason.id)
    expect(request.hospital_unit_id).to eq(unit.id)
    expect(request.notes).to eq("Some notes")
  end
end
