# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe Profile do
      it_behaves_like "an Accountable model"
      it_behaves_like "a Supersedable model"
      it :aggregate_failures do
        is_expected.to validate_presence_of(:patient)
        is_expected.to validate_presence_of(:prescriber)
        is_expected.to respond_to(:active)
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to belong_to(:dialysate)
        is_expected.to belong_to(:schedule_definition)
        is_expected.to be_versioned
      end
    end
  end
end
