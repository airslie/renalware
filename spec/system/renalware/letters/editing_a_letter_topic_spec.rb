module Renalware
  describe "Editing a letter's topic", :js do
    include LettersSpecHelper

    it "shows a validation error when the topic is cleared" do
      user = login_as_clinical
      patient = create(:letter_patient, by: user)
      topic = create(:letter_topic, text: "Original topic")
      letter = create(
        :draft_letter,
        patient:,
        topic:,
        description: topic.text,
        author: user,
        by: user
      )

      visit edit_patient_letters_letter_path(patient, letter)

      page.execute_script("document.getElementById('letter_topic_id').value = ''")
      submit_form

      expect(page).to have_text "Topic can't be blank"
      expect(page).to have_button t("btn.save")
      expect(letter.reload.topic).to eq(topic)
    end
  end
end
