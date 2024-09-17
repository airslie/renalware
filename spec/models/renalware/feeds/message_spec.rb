# frozen_string_literal: true

module Renalware
  describe Feeds::Message do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:header_id)
      is_expected.to validate_presence_of(:message_type)
      is_expected.to validate_presence_of(:event_type)
      is_expected.to validate_presence_of(:body)
      is_expected.to respond_to(:body_hash)
      is_expected.to have_db_index(:body_hash).unique(true)
      # Removing this test as we no longer rely on this index being there as
      is_expected.to have_db_index([:message_type, :event_type])
    end
  end
end
