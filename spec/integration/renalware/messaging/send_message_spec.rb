require "rails_helper"

feature "Sending a private message" do

  scenario "A clinician sends a private message about a patient", js: true do
    user = login_as_clinician
    patient = create(:messaging_patient, created_by: user, updated_by: user)
    create(:messaging_recipient, family_name: "X", given_name: "Y")

    visit patient_path(patient)

    click_on "Send message"

    fill_in "Body", with: "Test"
    select2 "X, Y", from: "#message_recipient_ids"
    click_on "Send"

    expect(page).to have_content("Message was successfully sent")
  end
end
