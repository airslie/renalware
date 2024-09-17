# frozen_string_literal: true

module Renalware
  describe Pathology::Charts::Series do
    it :aggregate_failures do
      is_expected.to belong_to(:chart)
      is_expected.to belong_to(:observation_description)
      is_expected.to validate_presence_of(:chart)
      is_expected.to validate_presence_of(:observation_description)
    end
  end
end
