# frozen_string_literal: true

require "rails_helper"

module Renalware::Events
  describe EventTypeAlertTrigger, type: :model do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:event_type)
    end
  end
end
