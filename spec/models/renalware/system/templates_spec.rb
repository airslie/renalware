# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe System::Template, type: :model do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:description)
      is_expected.to validate_presence_of(:body)
    end
  end
end
