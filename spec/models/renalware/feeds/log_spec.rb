# frozen_string_literal: true

module Renalware::Feeds
  describe Log do
    it :aggregate_failures do
      is_expected.to belong_to(:message)
      is_expected.to belong_to(:patient)
      is_expected.to validate_presence_of(:log_type)
      is_expected.to validate_presence_of(:log_reason)
    end
  end
end
