RSpec.describe "Assign a contact to a patient", :js do
  describe "creating a contact" do
    context "with valid attributes" do
      it "responds successfully" do
        user = login_as_clinical
        patient = create(:patient, by: user)
        person = create(:directory_person, by: user)
        contact_description = create(:letter_contact_description)
        visit patient_letters_contacts_path(patient)

        try_create_contact_with_valid_params(person, contact_description)

        expect_new_contact_for_patient
      end
    end

    context "with invalid attributes" do
      it "responds with errors" do
        user = login_as_clinical
        patient = create(:patient, by: user)
        visit patient_letters_contacts_path(patient)

        try_create_contact_with_invalid_params

        expect_to_display_errors
      end
    end

    def try_create_contact_with_valid_params(person, contact_description)
      click_on t("btn.add")

      within("#add-patient-contact-modal") do
        slim_select(
          person.family_name,
          from: "Person",
          wait_for: "Search term must be at least 3 characters"
        )
        select contact_description.to_s, from: "Description"
        submit_form
      end
    end

    def try_create_contact_with_invalid_params
      click_on t("btn.add")

      within("#add-patient-contact-modal") do
        submit_form
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
