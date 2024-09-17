# frozen_string_literal: true

module Renalware
  module Accesses
    describe Assessment do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to validate_presence_of(:type)
        is_expected.to validate_presence_of(:side)
        is_expected.to validate_presence_of(:performed_on)
        is_expected.to validate_timeliness_of(:performed_on)
        is_expected.to validate_timeliness_of(:procedure_on)
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to be_versioned
      end
    end
  end
end
