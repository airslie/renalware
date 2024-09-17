# frozen_string_literal: true

module Renalware
  describe "Editing a patient's demographics" do
    it "updates UKRDC settings" do
      user = login_as_admin
      patient = create(:patient, by: user)

      visit edit_patient_path(patient)

      within ".patient_ukrdc_anonymise" do
        choose "Yes"
      end
      fill_in "Anonymise decision on", with: "01-Apr-2024"
      fill_in "Anonymise recorded by", with: "Dr X"

      click_on "Save"

      expect(patient.reload).to have_attributes(
        ukrdc_anonymise: true,
        ukrdc_anonymise_decision_on: Date.parse("01-Apr-2024"),
        ukrdc_anonymise_recorded_by: "Dr X"
      )
    end
  end
end
