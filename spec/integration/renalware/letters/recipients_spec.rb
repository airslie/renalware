require "rails_helper"
require "test_support/autocomplete_helpers"
require "test_support/ajax_helpers"

RSpec.describe "Assign a person as a recipient", type: :feature, js: true do
  include AutocompleteHelpers
  include AjaxHelpers

  before do
    login_as_clinician
  end

  let(:primary_care_physician) { create(:letter_primary_care_physician) }
  let(:patient) { create(:letter_patient, primary_care_physician: primary_care_physician) }
  let(:address) { build(:address) }
  let!(:person) { create(:directory_person, address: address, by: create(:user)) }
  let(:user) { create(:user) }

  describe "assigning a new person as a main recipient" do
    before do
      create(:letter_letterhead)
      create(:letter_contact, patient: patient, person: create(:directory_person, by: user))
    end

    context "given valid attributes" do
      it "responds successfully" do
        visit patient_letters_letters_path(patient)
        click_on "Draft Letter"

        fill_out_letter

        try_adding_person_as_main_recipient

        select person.to_s, from: "letter_main_recipient_attributes_addressee_id"

        within ".top" do
          click_on "Create"
        end

        visit patient_letters_letters_path(patient)

        expect_letter_with_person_as_main_recipient
      end
    end

    def try_adding_person_as_main_recipient
      click_on "Add new person to contacts list"

      within("#add-patient-contact-modal") do
        fill_autocomplete "person_auto_complete",
          with: person.family_name, select: person.to_s

        click_on "Save"
      end

      wait_for_ajax

      expect(page).to_not have_text("Person must be unique to the patient")
    end

    def fill_out_letter
      fill_in "Date", with: I18n.l(Date.today)
      select Renalware::Letters::Letterhead.first.name, from: "Letterhead"
      select Renalware::User.first.to_s, from: "Author"
      fill_in "Description", with: "::description::"
      choose("Patient's Contact")
      wait_for_ajax
    end

    def expect_letter_with_person_as_main_recipient
      expect(page).to have_text(address.to_s)
    end
  end
end
