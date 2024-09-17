# frozen_string_literal: true

module Renalware
  describe "PD Training Session management", js: true do
    let(:patient) { create(:pd_patient) }

    it "Add a PD Training Session" do
      create(:pd_training_site, name: "Home")
      create(:pd_training_type, name: "APD Baxter")
      login_as_clinical

      visit patient_pd_dashboard_path(patient)

      # PD Summary
      within ".page-actions" do
        click_link "Add"
        click_link "PD Training Session"
      end

      # New
      started_on = l(Time.zone.today)
      select "Home", from: "Training site"
      select "APD Baxter", from: "Training type"
      fill_in input_called(:trainer), with: "Flo Nightengale RN"
      fill_in input_called(:started_on), with: started_on

      click_on t("btn.create")

      expect(page).to have_current_path(patient_pd_dashboard_path(patient))

      # Back on PD Summary
      within ".pd_training_sessions table tbody" do
        expect(page).to have_content("Home")
        expect(page).to have_content(started_on)
      end
    end

    it "Edit a PD Training Session" do
      user = login_as_clinical
      create(:pd_training_session, patient: patient, by: user)

      visit patient_pd_dashboard_path(patient)

      # PD Summary
      within ".pd_training_sessions table tbody" do
        click_on t("btn.edit")
      end

      # Edit - change a couple of fields
      within(".training_session_document_outcome") { choose("Successful") }

      click_on t("btn.save")

      # Back on PD Summary
      within ".pd_training_sessions table tbody" do
        expect(page).to have_content("Successful")
        # We don't need to test all fields, just that the ones we changed have updated.
      end
    end

    it "View a PD Training Session" do
      user = login_as_clinical
      training_session = create(:pd_training_session, patient: patient, by: user)

      visit patient_pd_dashboard_path(patient)

      # PD Summary
      within ".pd_training_sessions table tbody" do
        click_on t("btn.view")
      end

      # View
      doc = training_session.document
      within "article.pd_training_session_document" do
        expect(page).to have_content(l(doc.started_on))
        # No need to test presence of all items here - we just want to make
        # we are are in the right place and some is being displayed.
      end
    end

    def input_called(att)
      PD::TrainingSession::Document.human_attribute_name(att)
    end
  end
end
