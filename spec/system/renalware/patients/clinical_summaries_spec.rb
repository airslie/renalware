module Renalware
  describe "Clinical summary" do
    describe "GET show" do
      it "renders correctly" do
        user = login_as_clinical
        patient = create(:patient, by: user)
        create(:problem, patient:, by: user)
        create(:simple_event, patient:, by: user)
        create(:prescription, patient:, by: user)
        create(:admissions_admission, patient:, by: user)
        create(:admissions_consult, patient:, by: user)

        letter_patient = Letters.cast_patient(patient)
        letter = build(:approved_letter, patient: letter_patient, by: user)
        letter.build_main_recipient(person_role: :primary_care_physician)
        letter.type ||= letter.class.sti_name # TODO: RSpec timing makes this required
        letter.save!

        visit patient_clinical_summary_path(patient)

        expect(page).to have_text "Problems (1)"
        expect(page).to have_text "Events (1)"
        expect(page).to have_text "Letters (1)"
        expect(page).to have_text "Prescriptions (1)"
        expect(page).to have_text "Admissions (1)"
        expect(page).to have_text "Consults (1)"
        expect(page).to have_text "Messages"
      end
    end
  end
end
