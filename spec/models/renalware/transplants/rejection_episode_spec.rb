# frozen_string_literal: true

module Renalware
  module Transplants
    describe RejectionEpisode do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to be_versioned
        is_expected.to belong_to(:followup).touch(true)
        is_expected.to belong_to(:treatment)
        is_expected.to validate_presence_of(:followup_id)
        is_expected.to validate_presence_of(:recorded_on)
        is_expected.to validate_presence_of(:notes)
      end
    end
  end
end
