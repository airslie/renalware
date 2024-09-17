# frozen_string_literal: true

module Renalware
  describe "Redirect to dashboard when patient not found" do
    context "when patient is not found by secure_id" do
      it "going to the clinical summary redirects to the dashboard with a flash message" do
        login_as_clinical

        visit patient_clinical_summary_path(patient_id: "asdasdasdasdasdasd")

        expect(page).to have_current_path(dashboard_path)
        expect(page).to have_content("Patient not found")
      end

      it "going to demographics redirects to the dashboard with a flash message" do
        login_as_clinical

        visit patient_path(id: "asdasdasdasdasdasd")

        expect(page).to have_current_path(dashboard_path)
        expect(page).to have_content("Patient not found")
      end
    end
  end
end
