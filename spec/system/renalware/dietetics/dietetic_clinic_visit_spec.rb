# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Clinical
    describe "Dietetic Visit", js: true do
      let(:user) { create(:user, :clinical) }
      let(:patient) { create(:patient, by: user) }
      let(:clinic) {
        create(:clinic, name: "Dietetic", code: "D1",
                        visit_class_name: "Renalware::Dietetics::ClinicVisit")
      }
      let(:dry_weight) {
        create(:dry_weight, patient: Renalware::Clinical.cast_patient(patient),
                            weight: 123,
                            assessed_on: Date.parse("2020-10-10"))
      }

      before do
        clinic && dry_weight
      end

      it "allows the user to create & update a dietetic visit" do
        login_as user

        visit new_patient_clinic_visit_path(patient_id: patient)

        slim_select "Dietetic D1", from: "Clinic"

        # Test validations
        expect(page).to have_field "Previous weight"

        fill_in "Previous weight", with: "1"
        fill_in "Waist circumference", with: "1"
        fill_in "Estimated energy requirement", with: "1"

        click_button "Save"
        expect(page).to have_content "Date can't be blank"
        expect(page).to have_content "must be greater than or equal to 15" # Previous weight
        expect(page).to have_content "must be greater than or equal to 30" # Weist
        expect(page).to have_content "must be greater than or equal to 500" # Estimated energy requirement

        fill_in "Date", with: "20-07-2015 10:45"
        fill_in "Weight", with: "82.5"
        fill_in "Height", with: "1.78"

        within "section", text: "Dietetic Visit" do
          choose "Dietetic phone assessment"
          select "LCC", from: "Visit type"
          choose "DNA"
        end

        within_section "Weight", match: :first do
          fill_in "Weight notes", with: "Weight test notes"

          expect(page).to have_content "123.0 (10-Oct-2020) kg" # dry weight
          fill_in "Previous weight", with: "70"
          fill_in "Previous weight date", with: "20-Jul-2020"
          expect(page).to have_content "Weight change\n17.9%"
          expect(page).to have_content "26.0" # BMI
          fill_in "Adjusted BMI", with: "Add BMI"
          fill_in "Ideal body weight", with: "71"
          fill_in "Waist circumference", with: "80"
        end

        within_section "Dietary", match: :first do
          fill_in "Estimated protein requirement", with: "30"
          fill_in "Estimated protein intake", with: "40"
          fill_in "High biological value", with: "90"
          fill_in "Estimated energy requirement", with: "2000"
          fill_in "Estimated energy intake", with: "1900"
          expect(page).to have_content "0.6 g/day/kg" # Estimated protein intake
        end

        within_section "Handgrip", match: :first do
          fill_in "Left", with: "30"
          fill_in "Right", with: "10"
        end

        within_section "SGA", match: :first do
          choose "Severe malnutrition"
          fill_in "Plan", with: "Thorough plan"
          select "No change", from: "Intervention a"
          select "Fibre", from: "Intervention b"
          select "Potassium", from: "Intervention c"
        end

        within_section "Consultation time", match: :first do
          fill_in "Time for consultation", with: "10"
          fill_in "Time for documentation", with: "40"
          choose "12 months"
        end

        click_on "Save"

        # Get to index page
        within "h1" do
          expect(page).to have_content "Clinic Visits"
        end

        click_link "Toggle all rows"

        expect(page).to have_content "Assessment type\nDietetic phone assessment"
        expect(page).to have_content "Weight notes\nWeight test notes"
        expect(page).to have_content "Previous weight\n70"
        expect(page).to have_content "Weight change\n17.9%"
        expect(page).to have_content "Ideal body weight\n71"
        expect(page).to have_content "Waist circumference\n80"
        expect(page).to have_content "Estimated protein intake\n40"
        expect(page).to have_content "Estimated energy requirement\n2000"
        expect(page).to have_content "Estimated energy intake\n1900"
        expect(page).to have_content "High biological value\n90"
        expect(page).to have_content "Dominant hand\nright"
        expect(page).to have_content "Left\n30"
        expect(page).to have_content "Right\n10"
        expect(page).to have_content "Plan\nThorough plan"
        expect(page).to have_content "Sga assessment\nC - Severe malnutrition"
        expect(page).to have_content "Intervention a\nNo change"
        expect(page).to have_content "Intervention b\nFibre"
        expect(page).to have_content "Intervention c\nPotassium"

        # Now check the input fields are all filled out as expected
        click_link "Edit"

        within "section", text: "Dietetic Visit" do
          expect(page).to have_checked_field "Dietetic phone assessment"
          expect(page).to have_field "Visit type", with: "lcc"
          expect(page).to have_checked_field "DNA"
        end

        within_section "Weight", match: :first do
          expect(page).to have_field "Weight notes", with: "Weight test notes"

          expect(page).to have_content "123.0 (10-Oct-2020) kg" # dry weight
          expect(page).to have_field "Previous weight", with: "70"
          expect(page).to have_field "Previous weight date", with: "20-Jul-2020"
          expect(page).to have_content "26.0" # BMI
          expect(page).to have_field "Adjusted BMI", with: "Add BMI"
          expect(page).to have_field "Ideal body weight", with: "71"
          expect(page).to have_field "Waist circumference", with: "80"
        end

        within_section "Dietary", match: :first do
          expect(page).to have_field "Estimated protein requirement", with: "30"
          expect(page).to have_field "Estimated protein intake", with: "40"
          expect(page).to have_field "High biological value", with: "90"
          expect(page).to have_field "Estimated energy requirement", with: "2000"
          expect(page).to have_field "Estimated energy intake", with: "1900"
          expect(page).to have_content "0.6 g/day/kg" # Estimated protein intake
        end

        within_section "Handgrip", match: :first do
          expect(page).to have_field "Left", with: "30"
          expect(page).to have_field "Right", with: "10"
        end

        within_section "SGA", match: :first do
          expect(page).to have_checked_field "Severe malnutrition"
          expect(page).to have_field "Plan", with: "Thorough plan"
          expect(page).to have_field "Intervention a", with: "no_change"
          expect(page).to have_field "Intervention b", with: "fibre"
          expect(page).to have_field "Intervention c", with: "potassium"
        end

        within_section "Consultation time", match: :first do
          expect(page).to have_field "Time for consultation", with: "10"
          expect(page).to have_field "Time for documentation", with: "40"
          expect(page).to have_checked_field "12 months"
        end
      end
    end
  end
end
