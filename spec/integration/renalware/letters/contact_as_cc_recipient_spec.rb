# frozen_string_literal: true

require "rails_helper"

describe "Assign a person as a CC recipient", type: :system, js: true do
  include AjaxHelpers

  before do
    login_as_clinical
  end

  let(:practice) { create(:practice) }
  let(:primary_care_physician) { create(:letter_primary_care_physician) }
  let(:patient) do
    create(
      :letter_patient,
      primary_care_physician: primary_care_physician,
      practice: practice
    )
  end
  let(:address) { build(:address, name: "::cc_name::") }
  let!(:person) { create(:directory_person, address: address, by: create(:user)) }
  let(:user) { create(:user) }
  let!(:contact_description) { create(:letter_contact_description) }

  describe "assigning a new person as a CC recipient" do
    before {
      create(:letter_letterhead)
      create(:letter_description, text: "::description::")
    }

    context "with valid attributes" do
      it "adds the new contact to the contacts list on the letters form so it can be selected" do
        visit patient_letters_letters_path(patient)
        click_on "Create"
        click_on "Simple Letter"

        fill_out_letter

        try_adding_person_as_cc_recipient

        within ".top" do
          click_on "Create"
        end

        letter = patient.letters.last

        # Use the formatted route, otherwise we cannot check content in the iframe
        # of the regular show page.
        visit patient_letters_letter_formatted_path(patient, letter)

        expect_letter_with_person_as_cc_recipient
      end
    end

    def try_adding_person_as_cc_recipient
      click_on "Add new person to the list"

      within("#add-patient-contact-as-cc-modal") do
        select2(
          person.family_name,
          css: "#person-id-select2",
          search: true
        )
        select contact_description.name, from: "Description"
        fill_in "Notes", with: "some contact notes"
        click_on "Save"
      end

      wait_for_ajax

      expect(page).to have_text(person.family_name)

      expect(page).to have_no_text("is already a contact for the patient")
    end

    def fill_out_letter
      within "#letter-form" do
        fill_in "Date", with: I18n.l(Time.zone.today)
        select Renalware::Letters::Letterhead.first.name, from: "Letterhead"
        select Renalware::User.first.to_s, from: "Author"
        select2 "::description::", css: ".letter_description"
        choose("Primary Care Physician")
      end
      wait_for_ajax
    end

    def expect_letter_with_person_as_cc_recipient
      expect(page).to have_text(address.name)
    end
  end
end
