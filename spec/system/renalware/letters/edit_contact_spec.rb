# frozen_string_literal: true

describe "Managing an existing letter contact", js: true do
  include AjaxHelpers

  context "with valid parameters" do
    let(:user) { create(:user, :clinical) }

    it "A user changes an existing patient's contact to for example remove their default cc " \
       "or change their description", js: true do
      patient = create(:letter_patient)
      description1 = create(:letter_contact_description, name: "Parent")
      description2 = create(:letter_contact_description, name: "Child")
      person = create(:directory_person, by: user)
      contact = create(
        :letter_contact,
        patient: patient,
        description: description1,
        person: person,
        default_cc: true
      )

      login_as user
      visit patient_letters_contacts_path(patient)

      within "#letters_contact_#{contact.id}" do
        expect(page).to have_content("Yes")
        expect(page).to have_content("Parent")
        click_on t("btn.edit")
      end

      expect(page).to have_content("Edit Patient Contact")

      within "#edit-patient-contact-modal .letters_contact_default_cc" do
        # As the data behind this radio is a boolean false, simple_form/rails was adding the
        # readonly="readonly" attribute (https://github.com/plataformatec/simple_form/issues/1257),
        # and this causes Capybara 3.x to fail.
        # The solution is to set readonly: nil in the markup like this
        #   = f.input :default_cc, as: :inline_radio_buttons, readonly: nil
        choose "No"
      end

      select description2.name, from: "Description"

      click_on t("btn.save")

      # Wait for modal to close
      expect(page).to have_no_css("#edit-patient-contact-modal")

      contact.reload

      expect(contact.patient_id).to eq(patient.id)
      expect(contact.person_id).to eq(person.id)
      expect(contact.default_cc).to be_falsey
      expect(contact.description_id).to eq(description2.id)

      within "#letters_contact_#{contact.id}" do
        expect(page).to have_content("No")
        expect(page).to have_content("Child")
      end
    end
  end

  context "with invalid parameters" do
    it "A user cannot change an existing patient contact" do
      user = login_as_clinical
      patient = create(:letter_patient)
      create(
        :letter_contact,
        patient: patient,
        person: create(:directory_person, by: user),
        default_cc: true
      )

      login_as_clinical
      visit patient_letters_contacts_path(patient)

      within "#contacts table tbody tr:first-child" do
        click_on t("btn.edit")
      end

      wait_for_ajax

      # Specify neither a description or other description
      select "", from: "Description"
      fill_in "", with: "Other description"

      click_on t("btn.save")

      expect(page).to have_css(".modal__body .error-messages")
    end
  end
end
