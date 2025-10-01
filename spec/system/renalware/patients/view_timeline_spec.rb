RSpec.describe "A user views the timeline", :js do
  it "views the timeline" do
    user = create(:user, :clinical)
    patient = create(:patient, by: user)
    admission = create(:admissions_admission, patient:)
    consult = create(:admissions_consult, patient:, aki_risk: "yes")
    admission_created_by = admission.created_by.full_name
    consult_created_by = consult.created_by.full_name
    login_as user

    visit patient_path(patient)

    click_on "Timeline"

    expect(page).to have_content "Admission\tUnknown\t#{admission_created_by}"
    expect(page).to have_content "Consult\tAKI Risk: Yes\t#{consult_created_by}"

    first(:link, "Toggle").click

    expect(page).to have_content "Ward A"
  end
end
