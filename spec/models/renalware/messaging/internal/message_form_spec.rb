# frozen_string_literal: true

module Renalware::Messaging::Internal
  describe MessageForm do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:subject)
      is_expected.to validate_presence_of(:body)
    end
  end
end
