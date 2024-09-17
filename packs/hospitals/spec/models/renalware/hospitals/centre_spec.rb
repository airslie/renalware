# frozen_string_literal: true

module Renalware::Hospitals
  describe Centre do
    it :aggregate_failures do
      is_expected.to have_many(:departments)
      is_expected.to validate_presence_of(:code)
      is_expected.to validate_presence_of(:name)
      is_expected.to have_db_index(:abbrev)
      is_expected.to have_db_index(:code)
    end
  end
end
