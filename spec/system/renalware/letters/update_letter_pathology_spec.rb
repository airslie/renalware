# frozen_string_literal: true

module Renalware
  describe "Bringing in new pathology results into a letter while editing" do
    include LettersSpecHelper

    context "when there are no new pathology results" do
      it "a user edits a letter" do
        patient = create(:letter_patient)
        patient.primary_care_physician = create(:letter_primary_care_physician)
        create_initial_pathology_for(patient)
        letter = create_letter(patient)

        login_as_clinical
        visit edit_patient_letters_letter_path(patient, letter)

        within ".letter-pathology" do
          # expect(page).not_to have_content("Yes")
        end
      end
    end

    context "when there are new pathology results since the letters creation" do
      context "when the letter is being edited" do
        it "a user elects to refresh the letter's pathology" do
          patient = create(:letter_patient)
          patient.primary_care_physician = create(:letter_primary_care_physician)
          create_initial_pathology_for(patient)
          letter = create_letter(patient)

          expect(letter.pathology_timestamp).not_to be_blank
          expect(letter.clinical).to be(true)

          create_extra_pathology_for(patient)

          date = Time.zone.parse("2017-11-24 01:04:44")
          travel_to(date) do
            login_as_clinical
            visit edit_patient_letters_letter_path(patient, letter)

            expect(page).to have_content("Pathology")

            within ".letter-pathology" do
              choose "Yes"
            end

            submit_form

            letter.reload
            expect(letter.pathology_timestamp).to eq(date)
          end
        end
      end
    end

    def create_initial_pathology_for(patient)
      observation_request = create(
        :pathology_observation_request,
        patient: Pathology.cast_patient(patient)
      )
      hgb_description = create(
        :pathology_observation_description,
        code: "HGB",
        name: "HGB"
      )
      create(
        :pathology_observation,
        request: observation_request,
        description: hgb_description,
        observed_at: "05-Apr-2016",
        result: 1.1
      )
    end

    def create_extra_pathology_for(patient)
      # There has been a new OBR
      observation_request = create(
        :pathology_observation_request,
        patient: Pathology.cast_patient(patient)
      )
      plt_description = create(
        :pathology_observation_description,
        code: "PLT",
        name: "PLT"
      )
      create(
        :pathology_observation,
        request: observation_request,
        description: plt_description,
        observed_at: "06-Apr-2016",
        result: 2.2
      )
    end

    def create_letter(patient)
      Letters::LetterFactory.new(patient, clinical: true).build.tap do |letter|
        letter.description = create(:letter_topic).text
        letter.letterhead = create(:letter_letterhead)
        letter.author = User.first
        letter.by = User.first
        attributes = build_main_recipient_attributes(:patient)
        letter.main_recipient = build(:letter_recipient, :main, attributes)
        letter.save!
      end
    end
  end
end
