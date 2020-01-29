# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe System::Component, type: :model do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:class_name)
      is_expected.to validate_presence_of(:name)
    end
  end
end
