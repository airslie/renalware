module Renalware
  describe "Filtering sorting" do
    context "when sorting by modality" do
      it "if a patient has no modality they still appear in the list" do
        login_as_clinical
        patient_with_no_modality = create(:patient, family_name: "Rabbit", given_name: "Ronald")
        expect(patient_with_no_modality.current_modality).to be_nil
        create(:admissions_consult, patient: patient_with_no_modality, started_on: Time.zone.today)
        consults_page = Pages::Admissions::Consults.new.go
        expect(consults_page).to have_patient(patient_with_no_modality)

        consults_page.sort_by_modality

        expect(consults_page).to have_patient(patient_with_no_modality)
      end
    end
  end
end
