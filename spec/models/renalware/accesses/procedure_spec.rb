# frozen_string_literal: true

module Renalware
  module Accesses
    describe Procedure do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to validate_presence_of(:type)
        is_expected.to validate_presence_of(:performed_on)
        is_expected.to validate_presence_of(:performed_by)
        is_expected.to validate_timeliness_of(:performed_on)
        is_expected.to validate_timeliness_of(:first_used_on)
        is_expected.to validate_timeliness_of(:failed_on)
        is_expected.to belong_to(:pd_catheter_insertion_technique)
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to be_versioned
      end
    end
  end
end
