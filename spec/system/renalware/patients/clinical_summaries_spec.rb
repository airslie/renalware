# frozen_string_literal: true

module Renalware
  describe "Clinical summary" do
    describe "GET show" do
      it "renders correctly" do
        user = login_as_clinical
        patient = create(:patient, by: user)
        create(:problem, patient: patient, by: user)
        create(:simple_event, patient: patient, by: user)
        create(:prescription, patient: patient, by: user)
        create(:admissions_admission, patient: patient, by: user)
        create(:admissions_consult, patient: patient, by: user)

        letter_patient = Letters.cast_patient(patient)
        letter = build(:approved_letter, patient: letter_patient, by: user)
        letter.build_main_recipient(person_role: :primary_care_physician)
        letter.type ||= letter.class.sti_name # TODO: RSpec timing makes this required
        letter.save!

        visit patient_clinical_summary_path(patient)

        expect(page).to have_content "Problems (1)"
        expect(page).to have_content "Events (1)"
        expect(page).to have_content "Letters (1)"
        expect(page).to have_content "Prescriptions (1)"
        expect(page).to have_content "Admissions (1)"
        expect(page).to have_content "Consults (1)"
        expect(page).to have_content "Messages"
      end
    end
  end
end
