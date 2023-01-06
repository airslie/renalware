# frozen_string_literal: true

require "rails_helper"

module Renalware::Drugs
  describe Type do
    it :aggregate_failures do
      is_expected.to have_many(:classifications)
      is_expected.to have_many(:drugs).through(:classifications)
      is_expected.to be_versioned
    end
  end
end
