# frozen_string_literal: true

module Renalware
  module LowClearance
    describe Profile do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to validate_presence_of(:patient)
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to belong_to(:referrer)
        is_expected.to belong_to(:dialysis_plan)
        is_expected.to respond_to(:document)
        is_expected.to be_versioned
        is_expected.to have_db_index(:document)
        is_expected.to have_db_index(:patient_id)
      end
    end
  end
end
