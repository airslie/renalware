# frozen_string_literal: true

describe "Global Clinic Visits list" do
  describe "GET index" do
    it "responds successfully" do
      user = login_as_clinical
      patient = create(:clinics_patient, by: user, nhs_number: "2717073604")
      create(:clinic_visit, patient: patient, by: user)

      visit clinic_visits_path

      expect(page.status_code).to eq(200)
      expect(page).to have_content("2717073604")
    end
  end
end
