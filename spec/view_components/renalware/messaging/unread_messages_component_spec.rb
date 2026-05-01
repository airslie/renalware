describe Renalware::Messaging::UnreadMessagesComponent, type: :component do
  def send_message_to(user)
    form = Renalware::Messaging::Internal::MessageForm.new(
      body: "Content",
      subject: "Subject",
      recipient_ids: [user.id]
    )

    Renalware::Messaging::Internal::SendMessage.call(
      author: create(:internal_author),
      patient: create(:messaging_patient),
      form:
    )
    Renalware::Messaging::Internal::Message.first
  end

  context "when a user has unread messages" do
    it "displays the user's messages" do
      user = create(:user)
      message = send_message_to(user)

      render_inline(described_class.new(current_user: user))

      expect(page).to have_text("Messages")
      expect(page).to have_text(message.subject)
    end
  end

  context "when a user has no messages" do
    it "displays a no messages message" do
      user = create(:user)

      render_inline(described_class.new(current_user: user))

      expect(page).to have_text("Messages")
      expect(page).to have_text("You have no messages")
    end
  end
end
