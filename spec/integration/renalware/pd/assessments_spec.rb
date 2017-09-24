require "rails_helper"

module Renalware
  feature "PD Assessment management", js: true do
    ###
    scenario "Add a PD Assessment" do
      patient = create(:pd_patient)
      login_as_clinician

      visit patient_pd_dashboard_path(patient)

      # Summary
      within ".page-actions" do
        click_link "Add"
        click_link "PD Assessment"
      end

      # New
      home_visit_on = I18n.l(Time.zone.today)
      within(".assessment_document_had_home_visit") { choose("Yes") }
      within(".assessment_document_housing_type") { choose("Flat") }
      fill_in input_called(:assessor), with: "Flo Nightengale RN"
      fill_in input_called(:assessed_on), with: Time.zone.today
      fill_in input_called(:home_visit_on), with: home_visit_on
      fill_in input_called(:occupant_notes), with: "occupant_notes"
      fill_in input_called(:exchange_area), with: "exchange_area"
      fill_in input_called(:handwashing), with: "handwashing"
      fill_in input_called(:bag_warming), with: "bag_warming"
      fill_in input_called(:fluid_storage), with: "bag_warming"
      select "2 weeks", from: input_called(:delivery_interval)

      click_on "Save"

      expect(page.current_path).to eq(patient_pd_dashboard_path(patient))

      # Summary
      within ".pd_assessments table tbody" do
        expect(page).to have_content("Yes")
        expect(page).to have_content(home_visit_on)
      end
    end

    def input_called(att)
      PD::Assessment::Document.human_attribute_name(att)
    end

    ###
    scenario "Edit a PD Assessment" do
      patient = create(:pd_patient)
      user = login_as_clinician
      create(:pd_assessment, patient: patient, by: user)

      visit patient_pd_dashboard_path(patient)

      # Summary
      within ".pd_assessments table tbody" do
        click_on "Edit"
      end

      # Edit - change a couple of fields
      home_visit_on = I18n.l(Time.zone.today - 1.day)
      fill_in input_called(:home_visit_on), with: home_visit_on
      within(".assessment_document_had_home_visit") { choose("No") }

      click_on "Save"

      # Summary
      within ".pd_assessments table tbody" do
        expect(page).to have_content("No")
        expect(page).to have_content(home_visit_on)
        # We don't need to test all fields, just that the ones we changed have updated.
      end
    end

    ###
    scenario "View a PD Assessment" do
      patient = create(:pd_patient)
      user = login_as_clinician
      assessment = create(:pd_assessment, patient: patient, by: user)

      visit patient_pd_dashboard_path(patient)

      # Summary
      within ".pd_assessments table tbody" do
        click_on "View"
      end

      # View
      doc = assessment.document
      within "article.pd_assessment_document" do
        expect(page).to have_content(I18n.l(doc.home_visit_on))
        expect(page).to have_content(doc.occupant_notes)
        # No need to test presence of all items here - we just want to make
        # we are are in the right place and some is being displayed.
      end
    end
  end
end
