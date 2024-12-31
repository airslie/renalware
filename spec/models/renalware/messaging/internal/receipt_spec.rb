module Renalware::Messaging::Internal
  describe Receipt do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:recipient)
      is_expected.to validate_presence_of(:message)
      is_expected.to have_db_index(:recipient_id)
      is_expected.to have_db_index(:message_id)
      is_expected.to belong_to(:message).class_name("Renalware::Messaging::Internal::Message")
      is_expected.to belong_to(:recipient).touch(true)
    end

    describe "#read?" do
      it { is_expected.not_to be_read }

      it "returns true if read_at is set" do
        expect(described_class.new(read_at: Time.zone.now)).to be_read
      end
    end
  end
end
