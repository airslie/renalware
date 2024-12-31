describe "Sending a private message" do
  include AjaxHelpers

  it "A clinician sends a private message about a patient", :js do
    user = login_as_clinical
    patient = create(:messaging_patient, by: user)
    create(:internal_recipient, family_name: "X", given_name: "Y")

    visit patient_path(patient)

    click_on "Send message"

    wait_for_ajax

    fill_in "Body", with: "Test"

    # Problem here: select2 not initialised at this point.
    select2 "X, Y", from: "Recipients"
    click_on "Send"

    expect(page).to have_content("Message was successfully sent")

    # Message should be marked as public= true by default
    message = Renalware::Messaging::Internal::Message.find_by(body: "Test")
    expect(message.public).to be(true)
  end

  it "A clinician replies to a message", :js do
    user = login_as_clinical
    author = user.becomes(Renalware::Messaging::Internal::Author)
    patient = create(
      :messaging_patient,
      created_by: author,
      updated_by: author
    )
    other_recipient = create(:user, family_name: "X", given_name: "Y")

    # Create a messages and send to ourselves and another user
    form = Renalware::Messaging::Internal::MessageForm.new(
      body: "Content",
      subject: "Subject",
      recipient_ids: [other_recipient.id, user.id]
    )

    message = Renalware::Messaging::Internal::SendMessage.call(
      author: author,
      patient: patient,
      form: Renalware::Messaging::Internal::MessageForm.new(
        body: "Content",
        subject: "Subject",
        recipient_ids: form.recipient_ids
      )
    )

    visit messaging_internal_inbox_path

    within("#message-#{message.id}") do
      click_on("Toggle")
    end

    within("#message-preview-#{message.id}") do
      click_on("Reply")
    end

    within("#send-message-modal") do
      fill_in "Body", with: "My reply"
      click_on "Send"
    end

    # Message should have disappeared from inbox
    visit messaging_internal_inbox_path
    expect(page).to have_css("#unread-messages table tbody tr", count: 0)

    # Check that for the message we sent, only our receipt is marked as read
    expect(
      message
        .reload
        .receipts
        .where(read_at: nil)
        .pluck(:recipient_id)
    ).to eq([other_recipient.id])
  end
end
