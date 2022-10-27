# frozen_string_literal: true

require "rails_helper"

# This test currently targets a dummy patient/abridgements path so we can simulate
# a user searching for a patient in the master index, At some point that functionality will be moved
# to patients/new and this test will need updating.
describe "A user adds a patient", type: :system do
  describe "add patient flow" do
    let(:user) { create(:user, :clinical) }

    it "adds a patient successfully" do
      login_as user
      visit patients_path
      click_link "Add"

      expect(page).to have_field "Hospital centre", with: ""

      # Test for validation errors
      click_button "Save", match: :first

      expect(page).to have_content("Family name can't be blank")
      expect(page).to have_content("Given name can't be blank")
      expect(page).to have_content("Date of Birth can't be blank")
      expect(page).to have_content("Date of Birth is not a valid date")
      expect(page).to have_content("Sex is required")
      expect(page).to have_content("The patient must have at least one of these numbers: KCH, QEH, DVH, PRUH, GUYS, Other Hospital Number")

      fill_in "KCH No", with: "12345"
      fill_in "Family name", with: "FamilyName"
      fill_in "Given name", with: "GivenName"
      fill_in "DoB", with: "2022-12-09"
      select "Not Specified", from: "Sex"
      select "King's", from: "Hospital centre"

      # The save successfully, and go to the patient demographics page
      click_button "Save", match: :first

      expect(page).to have_content("Last Name:FamilyName")
      expect(page).to have_content("First Name:GivenName")
      expect(page).to have_content("Sex:NS")
      expect(page).to have_content("Date of Birth:09-Dec-2022")
      expect(page).to have_content("KCH No:12345")
      expect(page).to have_content("Hospital centre:King's College Hospital")
    end
  end

  describe "displaying search results that match user-entered criteria" do
    context "when an abridged patient exists in the master index" do
      it "displays the abridged patient" do
        login_as_clinical
        create(
          :abridged_patient,
          hospital_number: "KCH123",
          given_name: "John",
          family_name: "SMITH",
          born_on: "1967-01-01"
        )

        visit patients_abridgements_path

        fill_in "Search by hospital number or name", with: "KCH123"
        click_on "Search"

        expect(page).to have_content("SMITH, John")
      end

      context "when another unmatching abridged patient exists with same DOB" do
        let(:dob) { "1967-01-01" }

        it "displays the second patient under 'Patients matching by DOB' heading" do
          login_as_clinical
          create(
            :abridged_patient,
            hospital_number: "KCH123",
            given_name: "John",
            family_name: "SMITH",
            born_on: dob
          )
          create(
            :abridged_patient,
            hospital_number: "KCH456",
            given_name: "Jake",
            family_name: "OTHER",
            born_on: dob
          )
          create(:abridged_patient, family_name: "NOMATCH")

          visit patients_abridgements_path

          fill_in "Search by hospital number or name", with: "KCH123"
          click_on "Search"

          within(".search-results") do
            expect(page).to have_content("SMITH, John")
          end

          within(".search-results--by-dob") do
            expect(page).to have_content("OTHER, Jake")
            expect(page).not_to have_content("SMITH, John")
          end

          expect(page).not_to have_content("NOMATCH")
        end
      end
    end
  end
end
