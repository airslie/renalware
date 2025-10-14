module Renalware
  describe "Editing a patient's demographics" do
    before do
      allow(Renalware.config)
        .to receive(:disable_inputs_controlled_by_demographics_feed)
        .and_return(false)
    end

    it "updates UKRDC settings" do
      user = login_as_admin
      patient = create(:patient, by: user)

      visit edit_patient_path(patient)

      within ".patient_ukrdc_anonymise" do
        choose "Yes"
      end
      fill_in "Anonymise decision on", with: "01-Apr-2024"
      fill_in "Anonymise recorded by", with: "Dr X"
      fill_in "Family name", with: "Smith"

      click_on "Save"

      expect(patient.reload).to have_attributes(
        ukrdc_anonymise: true,
        ukrdc_anonymise_decision_on: Date.parse("01-Apr-2024"),
        ukrdc_anonymise_recorded_by: "Dr X",
        family_name: "Smith"
      )
    end

    context "when disable_inputs_controlled_by_demographics_feed is true" do
      before do
        allow(Renalware.config)
          .to receive(:disable_inputs_controlled_by_demographics_feed)
          .and_return(true)
      end

      it "prevents non super_admin users from editing certain patient attributes" do
        user = login_as_clinical
        patient = create(:patient, by: user)

        visit edit_patient_path(patient)

        expect(page).to have_current_path(edit_patient_path(patient))

        expect {
          fill_in "Family name", with: "Smith"
        }.to raise_error(Capybara::ElementNotFound) # because field is disabled

        fill_in "Other Hospital No.", with: "test" # not disabled

        click_on "Save"

        expect(patient.reload).to have_attributes(external_patient_id: "test")
      end

      it "allows super_admin users to edit a patient" do
        user = login_as_super_admin
        patient = create(:patient, by: user)

        visit edit_patient_path(patient)

        fill_in "Family name", with: "Smith"

        click_on "Save"

        expect(patient.reload).to have_attributes(family_name: "Smith")
      end
    end
  end
end
