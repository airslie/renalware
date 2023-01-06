# frozen_string_literal: true

require "rails_helper"

module Renalware::Drugs
  describe Classification do
    it :aggregate_failures do
      is_expected.to belong_to(:drug).touch(true)
      is_expected.to belong_to(:drug_type)
      is_expected.to be_versioned
    end
  end
end
