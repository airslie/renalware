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

      visit patient_clinical_profile_path(patient)

      expect(page).to have_text("Allergies")
      expect(page).to have_text("Peanuts")
    end

    it "shows allergy alert in patient banner" do
      user = login_as_clinical
      patient = create(:clinical_patient, family_name: "Smith", given_name: "John", by: user)
      create(:allergy, patient:, description: "Penicillin")

      visit patient_path(patient)

      expect(page).to have_css(".allergies").or have_text("Penicillin")
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

      visit patient_clinical_profile_path(patient)

      expect(page).to have_text("SMITH, John")
      expect(page).to have_no_text("Allergies")
      expect(page).to have_no_text("Peanuts")
    end

    it "does not show allergy alert in patient banner" do
      user = login_as_clinical
      patient = create(:clinical_patient, family_name: "Smith", given_name: "John", by: user)
      create(:allergy, patient:, description: "Penicillin")

      visit patient_path(patient)

      expect(page).to have_text("SMITH, John")
      expect(page).to have_no_css(".allergies")
      expect(page).to have_no_text("Penicillin")
    end
  end
end
