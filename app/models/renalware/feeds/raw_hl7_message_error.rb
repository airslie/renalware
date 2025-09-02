module Renalware
  module Feeds
    # If processing a RawHL7Message fails, we store it here for later inspection.
    class RawHL7MessageError < ApplicationRecord
      validates :body, presence: true
      validates :sent_at, presence: true
    end
  end
end
