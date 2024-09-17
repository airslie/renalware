# frozen_string_literal: true

module Renalware
  module HD
    describe PreferenceSet do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to validate_presence_of(:patient)
        is_expected.to validate_timeliness_of(:entered_on)
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to belong_to(:schedule_definition)
        is_expected.to be_versioned
      end
    end
  end
end
