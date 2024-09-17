# frozen_string_literal: true

module Renalware
  describe Letters::Archive do
    it_behaves_like "an Accountable model"
    it :aggregate_failures do
      is_expected.to validate_presence_of(:content)
      is_expected.to belong_to(:letter).touch(true)
    end
  end
end
