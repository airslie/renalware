module Renalware
  describe(
    "Toggle current problems & prescriptions when editing letter", :js
  ) do
    include LettersSpecHelper

    context "when a user is creating or editing a clinical letter" do
      it "they can toggle open the patient's prescriptions and problems to get context" do
        user = login_as_clinical
        patient = create(:letter_patient, by: user)
        problem = create(:problem, patient:, description: "Problem1", by: user)
        prescription = create(:prescription, patient:, by: user)

        visit new_patient_letters_letter_path(patient)

        within ".letter-form-problems-and-prescriptions" do
          expect(page).to have_text("Problems and Prescriptions")
          expect(page).to have_no_css(".problems")
          expect(page).to have_no_css(".prescriptions")

          click_on t("btn.toggle")

          expect(page).to have_css(".problems")
          expect(page).to have_css(".prescriptions")
          expect(page).to have_text(problem.description)
          expect(page).to have_text(prescription.drug_name)
        end
      end
    end
  end
end
