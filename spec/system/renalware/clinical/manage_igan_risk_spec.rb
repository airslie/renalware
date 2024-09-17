# frozen_string_literal: true

module Renalware
  module Clinical
    describe "IgAN risk via the clinical profile" do
      it "entering a new IgAN risk" do
        clinical_patient = create(:clinical_patient)
        login_as_clinical
        visit patient_clinical_profile_path(clinical_patient)

        expect(page).to have_no_css("#igan_risk")

        within ".page-actions" do
          click_on "Add"
          click_on "IgAN Risk"
        end

        fill_in "Risk", with: "53.99"
        fill_in "Workings", with: ("A" * 200)
        within ".form-actions" do
          click_on "Create"
        end

        expect(page).to have_current_path(patient_clinical_profile_path(clinical_patient))

        within "#igan_risk" do
          expect(page).to have_content("53.99")
          expect(page).to have_content(("A" * 10))
        end
      end

      it "updating the IgAN risk" do
        clinical_patient = create(:clinical_patient)
        user = login_as_clinical
        clinical_patient.build_igan_risk(risk: 12.34, workings: "abc", by: user).save!
        visit patient_clinical_profile_path(clinical_patient)

        within "#igan_risk" do
          click_on "Update"
        end

        fill_in "Risk", with: "53.99"
        fill_in "Workings", with: ("A" * 300)
        within ".form-actions" do
          click_on "Save"
        end

        expect(page).to have_current_path(patient_clinical_profile_path(clinical_patient))

        within "#igan_risk" do
          expect(page).to have_content("53.99")
          expect(page).to have_content(("A" * 10))
        end
      end
    end
  end
end
