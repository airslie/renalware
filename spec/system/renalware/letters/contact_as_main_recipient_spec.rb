RSpec.describe "Assign a person as a main recipient" do
  before do
    login_as_clinical
  end

  let(:primary_care_physician) { create(:letter_primary_care_physician) }
  let(:patient) { create(:letter_patient, primary_care_physician:) }
  let(:address) { build(:address) }
  let!(:person) { create(:directory_person, address:, by: create(:user)) }
  let(:user) { create(:user) }
  let!(:contact_description) { create(:letter_contact_description) }

  describe "assigning a new person as a main recipient", :js do
    before do
      create(:letter_letterhead)
      create(:letter_contact, patient:, person: create(:directory_person, by: user))
      create(:letter_topic, text: "::description::")
    end

    context "with valid attributes" do
      it "responds successfully" do
        visit patient_letters_letters_path(patient)
        click_on t("btn.create_")
        click_on "Simple Letter"

        fill_out_letter

        try_adding_person_as_main_recipient

        select person.to_s, from: "letter_main_recipient_attributes_addressee_id"

        submit_form

        visit patient_letters_letters_path(patient)

        expect_letter_with_person_as_main_recipient
      end
    end

    def try_adding_person_as_main_recipient
      click_on "Add a different recipient via the contacts Directory"

      within("#add-patient-contact-modal") do
        select2(
          person.family_name,
          css: "#person-id-select",
          search: true
        )
        select contact_description.name, from: "Description"

        click_on "Create"
      end

      expect(page).to have_no_text("is already a contact for the patient")
    end

    def fill_out_letter
      slim_select "::description::", from: "Topic"
      within "#letter-form" do
        select Renalware::Letters::Letterhead.first.name, from: "Letterhead"
      end

      slim_select Renalware::User.first.to_s, from: "Author"

      within "#letter-form" do
        choose("Patient's Contact")
      end
    end

    def expect_letter_with_person_as_main_recipient
      expect(page).to have_text(address.to_s)
    end
  end
end
