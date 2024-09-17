# frozen_string_literal: true

describe "View global letters list", js: false do
  include LettersSpecHelper

  describe "GET #show" do
    it "returns a list of letters" do
      primary_care_physician = create(:letter_primary_care_physician)
      patient = create(:letter_patient, primary_care_physician: primary_care_physician)
      create_letter(to: :patient, patient: patient)

      login_as_clinical

      visit letters_list_path

      expect(page.status_code).to eq(200)
      expect(page).to have_content(patient.to_s)
    end
  end
end
