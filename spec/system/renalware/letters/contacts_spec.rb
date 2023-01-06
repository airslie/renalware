# frozen_string_literal: true

require "rails_helper"

describe "Assign a contact to a patient", js: true do
  include AjaxHelpers

  before do
    @user = login_as_clinical
  end

  let(:patient) { create(:patient, by: @user) }
  let!(:person) { create(:directory_person, by: @user) }
  let!(:contact_description) { create(:letter_contact_description) }

  describe "creating a contact" do
    context "with valid attributes" do
      it "responds successfully" do
        visit patient_letters_contacts_path(patient)

        try_create_contact_with_valid_params

        expect_new_contact_for_patient
      end
    end

    context "with invalid attributes" do
      it "responds with errors" do
        visit patient_letters_contacts_path(patient)

        try_create_contact_with_invalid_params

        expect_to_display_errors
      end
    end

    def try_create_contact_with_valid_params
      click_on t("btn.add")

      within("#add-patient-contact-modal") do
        select2(
          person.family_name,
          css: "#person-id-select2",
          search: true
        )
        select contact_description.to_s, from: "Description"
        click_on t("btn.save")
      end

      wait_for_ajax
    end

    def try_create_contact_with_invalid_params
      click_on t("btn.add")

      within("#add-patient-contact-modal") do
        click_on t("btn.save")
      end
    end

    def expect_new_contact_for_patient
      expect(page).to have_css("#contacts tbody tr", count: 1)
    end

    def expect_to_display_errors
      expect(page).to have_css(".error-messages")
    end
  end
end
