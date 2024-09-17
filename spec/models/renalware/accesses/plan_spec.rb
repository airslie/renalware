# frozen_string_literal: true

module Renalware::Accesses
  describe Plan do
    it_behaves_like "an Accountable model"
    it :aggregate_failures do
      is_expected.to validate_presence_of(:plan_type)
      is_expected.to validate_presence_of(:decided_by)
    end
  end
end
