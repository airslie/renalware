# frozen_string_literal: true

module Renalware::Feeds
  describe FileType do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:description)
      is_expected.to validate_presence_of(:prompt)
      is_expected.to have_many(:files)
    end
  end
end
