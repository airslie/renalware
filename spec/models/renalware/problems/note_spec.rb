# frozen_string_literal: true

module Renalware::Problems
  describe Note do
    it_behaves_like "a Paranoid model"
    it_behaves_like "an Accountable model"
    it :aggregate_failures do
      is_expected.to belong_to(:problem).touch(true)
      is_expected.to validate_presence_of(:description)
    end
  end
end
