# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Feeds::Message do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:header_id)
      is_expected.to validate_presence_of(:event_code)
      is_expected.to validate_presence_of(:body)
      is_expected.to respond_to(:body_hash)
      is_expected.to have_db_index(:body_hash).unique(true)
    end
  end
end
