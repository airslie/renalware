describe Renalware::Patients::MessagesComponent, type: :component do
  def send_message_about(patient:, to:, subject: "subject1", body: "body1")
    form = Renalware::Messaging::Internal::MessageForm.new(
      body: body,
      subject: subject,
      recipient_ids: [to.id]
    )

    Renalware::Messaging::Internal::SendMessage.call(
      author: to,
      patient: patient,
      form: form
    )
    Renalware::Messaging::Internal::Message.first
  end

  context "when a patient has messages about them" do
    it "displays them as a table" do
      user = create(:internal_author)
      patient = create(:messaging_patient, by: user)
      send_message_about(
        patient: patient,
        to: user,
        body: "B1"
      )

      component = described_class.new(
        patient: patient,
        current_user: user
      )

      render_inline(component)

      expect(page).to have_content("Messages")
      expect(page).to have_content("B1")
      expect(page).to have_content(l(Date.current))
      expect(page).to have_content(user.to_s)
    end
  end

  context "when a patient has messages about them" do
    it "displays a 'no messages' message!" do
      user = create(:patients_user)
      patient = create(:patient, by: user)

      render_inline(described_class.new(patient: patient, current_user: user))

      expect(page).to have_content("Messages")
      expect(page).to have_content("No messages")
    end
  end
end
