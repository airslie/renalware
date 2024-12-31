describe("Persisting the correct recipients when a letter is saved", :js) do
  include AjaxHelpers

  let(:practice) { create(:practice) }
  let(:primary_care_physician) { create(:letter_primary_care_physician) }
  let(:patient) do
    create(
      :letter_patient,
      cc_on_all_letters: true,
      primary_care_physician: primary_care_physician,
      practice: practice
    )
  end
  let(:address) { build(:address, name: "::cc_name::") }

  def draft_new_letter(user, main_recipient_person_role:)
    form_page = Pages::Letters::PatientLetters.new.go(patient).create_simple_letter
    form_page.letterhead = Renalware::Letters::Letterhead.first.name
    form_page.author = user
    form_page.description = "::description::"
    form_page.main_recipient = main_recipient_person_role
    yield(form_page) if block_given?
    form_page.submit
  end

  def approve_letter
    # navigate through the submission process
    accept_alert do
      click_on "Submit for Review"
    end
    accept_alert do
      click_on "Approve and archive"
    end

    expect(page).to have_current_path(patient_clinical_summary_path(patient))

    # Sanity checks
    expect(patient.letters.count).to eq(1)

    letter = patient.letters.first
    expect(letter).to be_approved
    letter
  end

  context "when the main recipient is one of patient or primary_care_physician" do
    PERSON_ROLES = %i(patient primary_care_physician).freeze
    PERSON_ROLES.each do |main_person_role|
      cc_person_role = (PERSON_ROLES - [main_person_role]).first

      context "when the main recipient is #{main_person_role} and there are no extra CCs" do
        it "create recipients rows main:#{main_person_role} cc:#{cc_person_role}" do
          user = login_as_clinical
          create(:letter_letterhead)
          create(:letter_topic, text: "::description::")

          draft_new_letter(user, main_recipient_person_role: main_person_role)
          letter = approve_letter

          expect(letter.recipients.count).to eq(2) # 1 main, 1 cc
          main = letter.recipients.find_by!(role: :main)
          cc = letter.recipients.find_by!(role: :cc)

          expect(main.person_role).to eq(main_person_role)
          expect(cc.person_role).to eq(cc_person_role)
        end
      end
    end
  end

  context "when main recipient is a contact", :js do
    it "create recipient rows main: contact cc: [patient primary_care_physician]" do
      user = login_as_clinical
      create(:letter_letterhead)
      create(:letter_topic, text: "::description::")
      create(
        :letter_contact,
        patient: patient,
        person: create(:directory_person, family_name: "Smith", given_name: "John")
      )

      draft_new_letter(user, main_recipient_person_role: :contact) do |form|
        form.main_recipient_contact_name = "Smith"
      end

      # navigate through the submission process
      accept_alert do
        # Alert: Are you sure?
        click_on "Submit for Review"
      end
      wait_for_ajax
      accept_alert do
        # Alert: Are you sure? You will not be able to modify the letter afterwards.
        click_on "Approve and archive"
      end
      # wait to get back to the Clinical Summary page
      expect(page).to have_content "Clinical Summary"

      # Sanity checks
      expect(patient.letters.count).to eq(1)
      letter = patient.letters.first

      expect(letter).to be_approved

      expect(letter.recipients.count).to eq(3) # 1 main, 2 cc
      main = letter.recipients.find_by!(role: :main)
      ccs = letter.recipients.where(role: :cc)

      expect(ccs.count).to eq(2)
      expect(main.person_role).to eq("contact")
      expect(ccs.map(&:person_role)).to eq(%w(patient primary_care_physician))
    end
  end
end
