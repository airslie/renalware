# frozen_string_literal: true

require "rails_helper"

describe "Managing a patient's comorbidities" do
  include ActionView::RecordIdentifier

  # rubocop:disable RSpec/MultipleExpectations
  describe "viewing comorbidities" do
    it "displays date + Yes/No/Unknown for any comorbids the patient has, and Unknown for others" do
      user = login_as_clinical
      patient = create(:patient, by: user)

      desc1 = Renalware::Problems::Comorbidities::Description.create!(name: "Xxx", position: 1)
      desc2 = Renalware::Problems::Comorbidities::Description.create!(name: "Yyy", position: 2)

      comob = patient.comorbidities.create!(
        description: desc1,
        recognised: "yes",
        recognised_at: "2010-02-01",
        by: user
      )

      visit renalware.patient_comorbidities_path(patient)

      within("table.comorbidities ##{dom_id(desc1)}") do
        expect(page).to have_content desc1.name
        expect(page).to have_content I18n.l(comob.recognised_at)
        expect(page).to have_content "Yes"
      end

      within("table.comorbidities ##{dom_id(desc2)}") do
        expect(page).to have_content desc2.name
        expect(page).not_to have_content "Unknown"
        expect(page).not_to have_content "Yes"
        expect(page).not_to have_content "No"
      end
    end
  end
  # rubocop:enable RSpec/MultipleExpectations

  describe "editing comorbidities" do
    it do
      user = login_as_clinical
      patient = create(:patient, by: user)

      desc1 = Renalware::Problems::Comorbidities::Description.create!(name: "Xxx", position: 1)
      desc2 = Renalware::Problems::Comorbidities::Description.create!(name: "Yyy", position: 2)

      visit renalware.edit_patient_comorbidities_path(patient)

      expect(page).to have_content desc1.name
      expect(page).to have_content desc2.name

      within("##{dom_id(desc1)}") do
        choose "Yes"
        find(:css, ".datepicker2").set("2010-01-01")
      end

      within("##{dom_id(desc2)}") do
        choose "No"
      end

      within "#comorbidities-form" do
        click_on "Save"
      end
    end
  end
end
