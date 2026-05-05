# frozen_string_literal: true

module Renalware
  RSpec.describe "HD Dashboard", :js do
    let(:clinician) { create(:user, :clinical) }
    let(:patient) { create(:hd_patient) }
    let(:assessment) { create(:hd_acuity_assessment, patient:) }
    let(:pdf) { "renalware/hd_acuity_score_guide.pdf" }

    before do
      assessment
      login_as clinician
    end

    it "renders the patient's HD Summary" do
      visit patient_hd_dashboard_path(patient)

      expect(page).to have_text(patient.to_s)

      expect(page).to have_text("HD Summary")
      within(".acuity-assessments") do
        expect(page).to have_text("Acuity Assessments")
        expect(page).to have_css("a[href$='.pdf'][target='_blank']")
      end
    end

    context "when the patient has no HD Assessments" do
      let(:assessment) { nil }

      it "renders the patient's HD Summary" do
        visit patient_hd_dashboard_path(patient)

        expect(page).to have_text("HD Summary")
        expect(page).to have_no_text("Acuity Assessments")
      end
    end

    context "when adding an acuity assessment from page actions" do
      it "displays the add page" do
        visit patient_hd_dashboard_path(patient)

        within(".page-actions") do
          click_on "Add…"
          click_on "Acuity Assessment"
        end

        expect(page).to have_text("New HD Acuity Assessment")
      end
    end

    context "when adding an acuity assessment from the acuity assessments table" do
      it "returns to the patient's HD Summary once the form is submitted" do
        visit patient_hd_dashboard_path(patient)

        within(".acuity-assessments") do
          click_on "Add"
        end

        expect(page).to have_text("New HD Acuity Assessment")

        choose "1:4"
        click_on "Create"

        expect(page).to have_current_path(patient_hd_dashboard_path(patient))
        expect(page).to have_text("Acuity assessment added")
      end
    end
  end
end
