# frozen_string_literal: true

module Renalware::Drugs
  describe Type do
    it :aggregate_failures do
      is_expected.to have_many(:drug_type_classifications)
      is_expected.to have_many(:drugs).through(:drug_type_classifications)
      is_expected.to be_versioned
    end
  end
end
