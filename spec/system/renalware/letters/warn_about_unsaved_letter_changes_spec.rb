module Renalware
  describe "Warn about unsaved changes when leaving a letter form", :js do
    include LettersSpecHelper

    let(:patient) { create(:letter_patient) }

    before do
      login_as_clinical
      create(:letter_letterhead, name: "Letterhead")
      create(:letter_topic, text: "Some Topic")
    end

    def dialog_shown?(&)
      page.driver.dismiss_modal(:beforeunload, wait: 1, &)
      true
    rescue Capybara::ModalNotFound
      false
    end

    it "does not warn when leaving a form with no changes" do
      visit new_patient_letters_letter_path(patient)

      expect(dialog_shown? { click_link t("btn.cancel") }).to be(false)
      expect(page).to have_current_path(patient_letters_letters_path(patient))
    end

    it "warns when leaving a form with unsaved changes" do
      visit new_patient_letters_letter_path(patient)
      fill_in "Salutation", with: "Dear Doctor"

      pending "removed the stimulus controller form new and edit forms for now"

      expect(dialog_shown? { click_link t("btn.cancel") }).to be(true)

      # Dismissing the warning keeps the user on the page with their changes intact
      expect(page).to have_field("Salutation", with: "Dear Doctor")
    end

    it "lets the user leave anyway once they confirm the warning" do
      visit new_patient_letters_letter_path(patient)
      fill_in "Salutation", with: "Dear Doctor"

      pending "removed the stimulus controller form new and edit forms for now"

      page.driver.accept_modal(:beforeunload, wait: 1) { click_link t("btn.cancel") }

      expect(page).to have_current_path(patient_letters_letters_path(patient))
    end

    it "does not warn when a change is made and then reverted back to the original value" do
      visit new_patient_letters_letter_path(patient)
      original_salutation = find_field("Salutation").value

      fill_in "Salutation", with: "Dear Doctor"
      fill_in "Salutation", with: original_salutation

      expect(dialog_shown? { click_link t("btn.cancel") }).to be(false)
    end

    it "does not warn when leaving after successfully saving the form" do
      visit new_patient_letters_letter_path(patient)

      select "Letterhead", from: "Letterhead"
      slim_select "Some Topic", from: "Topic"
      fill_in "Salutation", with: "Dear Doctor"

      expect(dialog_shown? { submit_form }).to be(false)
      expect(page).to have_current_path(
        patient_letters_letter_path(patient, Letters::Letter.last)
      )
    end
  end
end
