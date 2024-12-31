module Renalware::Feeds
  describe MessageReplay do
    subject { described_class.new }

    it :aggregate_failures do
      is_expected.to validate_presence_of(:replay_request_id)
      is_expected.to validate_presence_of(:message_id)
      is_expected.to validate_presence_of(:urn)
      is_expected.to belong_to :replay_request
      is_expected.to belong_to :message
    end
  end
end
