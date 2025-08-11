RSpec.describe "A user views the timeline", :js do
  it "views the timeline" do
    user = create(:user, :clinical)
    patient = create(:patient, by: user)
    admission = create(:admissions_admission, patient:)
    created_by = admission.created_by.full_name
    login_as user

    visit patient_path(patient)

    click_on "Timeline"

    expect(page).to have_content "Admission\tUnknown\t#{created_by}"

    click_on "Toggle"

    expect(page).to have_content "Ward A"
  end
end
