describe Renalware::Messaging::UnreadMessageCountComponent, type: :component do
  let(:internal_author) { create(:internal_author) }
  let(:messaging_patient) { create(:messaging_patient) }

  def send_message_to(user)
    form = Renalware::Messaging::Internal::MessageForm.new(
      body: "Content",
      subject: "Subject",
      recipient_ids: [user.id]
    )

    Renalware::Messaging::Internal::SendMessage.call(
      author: internal_author,
      patient: messaging_patient,
      form: form
    )
    Renalware::Messaging::Internal::Message.first
  end

  context "when a user has unread messages" do
    it "displays number of messages in a 'badge' style" do
      user = create(:user)
      send_message_to(user)
      send_message_to(user)

      render_inline(described_class.new(current_user: user))

      expect(page.text).to eq("2")
    end
  end

  context "when a user has >99 unread messages" do
    it "displays '99+" do
      user = create(:user)
      100.times { send_message_to(user) } # not a very well behaved test...

      render_inline(described_class.new(current_user: user))

      expect(page.text).to eq("99+")
    end
  end

  context "when a user has no unread messages" do
    it "renders nothing" do
      user = create(:user)
      component = described_class.new(current_user: user)
      render_inline(component)

      expect(component.render?).to be(false)
      expect(page.text).to be_blank
    end
  end
end
