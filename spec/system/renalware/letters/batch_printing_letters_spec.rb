# frozen_string_literal: true

describe "Batch printing letters", js: true do
  include LettersSpecHelper
  include ActiveJob::TestHelper

  context "when a user filters all letter by a particular author" do
    it "todo" do
      user = login_as_clinical
      letter1 = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
        page_count: 1,
        user: user
      )
      letter2 = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
        page_count: 1,
        user: user
      )

      visit letters_list_path

      expect(page).to have_content(letter1.author.to_s)
      expect(page).to have_content(letter2.author.to_s)

      slim_select letter1.author.to_s, from: "Author"

      within ".letters-table" do
        expect(page).to have_content(letter1.author.to_s)
        expect(page).to have_no_content(letter2.author.to_s)
      end
    end
  end

  # context "when I click the Batch Print button" do
  #   it "reloads the page" do
  #     login_as_clinical

  #     visit letters_list_path
  #     click_on "Batch Print"

  #     expect(page).to have_current_path(letters_list_path)
  #   end
  # end

  # context "when I click the Batch Print button" do
  #   it "kicks off a background job" do
  #     login_as_clinical

  #     visit letters_list_path
  #     click_on "Batch Print"

  #     expect(enqueued_jobs.size).to eq(1)
  #   end
  # end
end
