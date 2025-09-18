describe "Managing a patient's allergies", :js do
  let(:clinician) { create(:user, :clinical) }
  let(:patient) { create(:patient) }
  let(:clinical_patient) { Renalware::Clinical.cast_patient(patient) }

  before do
    login_as(clinician)
  end

  describe "adding allergies to a patient" do
    it "allows a clinician to add multiple allergies via the UI" do
      allergy_page = Pages::Clinical::AllergyPage.new(patient).go

      allergy_page.add_allergy("Nuts")
      allergy_page.add_allergy("Penicillin")

      # Verify allergies appear in the UI
      within ".clinical-allergies" do
        expect(page).to have_content("Nuts")
        expect(page).to have_content("Penicillin")
      end

      # Verify allergies are persisted in database
      expect(clinical_patient.allergies.pluck(:description)).to contain_exactly("Nuts",
                                                                                "Penicillin")

      # Verify status form is disabled when allergies exist
      within ".clinical-allergies" do
        expect(page).to have_css(".allergy-status-form .disabled")
      end
    end
  end

  describe "removing allergies and marking as No Known Allergies" do
    before do
      # Add allergies via domain logic to set up test state
      clinical_patient.allergies.create!(
        description: "Nuts",
        recorded_at: Time.zone.now,
        by: clinician
      )
      clinical_patient.allergies.create!(
        description: "Penicillin",
        recorded_at: Time.zone.now,
        by: clinician
      )
    end

    it "allows removing allergies and then marking patient as having No Known Allergies" do
      allergy_page = Pages::Clinical::AllergyPage.new(patient).go

      # Remove allergies
      nuts_allergy = clinical_patient.allergies.find_by(description: "Nuts")
      penicillin_allergy = clinical_patient.allergies.find_by(description: "Penicillin")

      allergy_page.remove_allergy(nuts_allergy)
      expect(allergy_page.exists?(nuts_allergy)).to be(false)

      allergy_page.remove_allergy(penicillin_allergy)
      expect(allergy_page.exists?(penicillin_allergy)).to be(false)

      # Verify no active allergies remain
      expect(clinical_patient.allergies.pluck(:description)).to be_empty

      # Verify archived allergies exist
      expect(clinical_patient.allergies.only_deleted.pluck(:description)).to contain_exactly(
        "Penicillin", "Nuts"
      )

      # Verify can mark as No Known Allergies
      expect(allergy_page.status_form_disabled?).to be(true)
      allergy_page.mark_patient_as_having_no_known_allergies

      # Verify status is updated
      expect(clinical_patient.reload.allergy_status).to eq("no_known_allergies")
    end
  end
end
