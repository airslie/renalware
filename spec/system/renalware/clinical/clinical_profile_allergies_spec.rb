# frozen_string_literal: true

describe "Clinical Profile Allergies Display" do
  context "when allergies are enabled" do
    before do
      allow(Renalware.config).to receive(:enable_allergies).and_return(true)
    end

    it "displays allergy section in clinical profile" do
      user = login_as_clinical
      patient = create(:clinical_patient, family_name: "Smith", given_name: "John", by: user)
      create(:allergy, patient:, description: "Peanuts")

      visit renalware.patient_clinical_profile_path(patient)

      expect(page).to have_content("Allergies")
      expect(page).to have_content("Peanuts")
    end

    it "shows allergy alert in patient banner" do
      user = login_as_clinical
      patient = create(:clinical_patient, family_name: "Smith", given_name: "John", by: user)
      create(:allergy, patient:, description: "Penicillin")

      visit renalware.patient_path(patient)

      expect(page).to have_css(".allergies").or have_content("Penicillin")
    end
  end

  context "when allergies are disabled" do
    before do
      allow(Renalware.config).to receive(:enable_allergies).and_return(false)
    end

    it "does not display allergy section in clinical profile" do
      user = login_as_clinical
      patient = create(:clinical_patient, family_name: "Smith", given_name: "John", by: user)
      create(:allergy, patient:, description: "Peanuts")

      visit renalware.patient_clinical_profile_path(patient)

      expect(page).to have_content("SMITH, John")
      expect(page).to have_no_content("Allergies")
      expect(page).to have_no_content("Peanuts")
    end

    it "does not show allergy alert in patient banner" do
      user = login_as_clinical
      patient = create(:clinical_patient, family_name: "Smith", given_name: "John", by: user)
      create(:allergy, patient:, description: "Penicillin")

      visit renalware.patient_path(patient)

      expect(page).to have_content("SMITH, John")
      expect(page).to have_no_css(".allergies")
      expect(page).to have_no_content("Penicillin")
    end
  end
end
