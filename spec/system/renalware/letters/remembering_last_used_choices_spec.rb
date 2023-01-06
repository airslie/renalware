# frozen_string_literal: true

require "rails_helper"

describe "Remembering last used letter choices in the user's session", js: true do
  it "once a letter is created, subsequent new letters remember letterhead, author, " \
     "date and description" do
    patient = create(
      :letter_patient,
      primary_care_physician: create(:letter_primary_care_physician),
      practice: create(:practice)
    )
    letterheads = [
      create(:letter_letterhead, name: "LetterHeadA"),
      create(:letter_letterhead, name: "LetterHeadB")
    ]
    descriptions = [
      create(:letter_topic, text: "LetterDescriptionA"),
      create(:letter_topic, text: "LetterDescriptionB")
    ]
    users = [
      login_as_clinical,
      create(:user, family_name: "Jones", given_name: "Jane")
    ]

    visit new_patient_letters_letter_path(patient)

    # Check the intial defaults - all to be blank (because its a new session) apart from author
    # which will default to current user
    expect(page.find("#letter_author_id option[selected='selected']").value)
      .to eq(users[0].id.to_s)
    expect(page.find("#letter_letterhead_id").value).to eq("")
    expect(page).not_to have_selector :css, "#letter_topic option[selected='selected']"

    # Now fill in some fields. These fields are in RememberedPreferences (saved to a cookie) so
    # should be remembered the next time we create a letter
    select letterheads[1].name, from: "Letterhead"
    select "Jones, Jane", from: "Author"
    slim_select descriptions[1].text, from: "Topic"
    choose("Primary Care Physician")

    within ".top" do
      click_on t("btn.create")
    end

    # Now create another letter to test it has remebered our previous choices
    visit new_patient_letters_letter_path(patient)

    expect(page.find("#letter_letterhead_id").value).to eq(letterheads[1].id.to_s)
    expect(page).to have_field "Topic", with: descriptions[1].id.to_s, visible: false
    expect(page.find("#letter_author_id option[selected='selected']").value)
      .to eq(users[1].id.to_s)
  end
end
