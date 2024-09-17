# frozen_string_literal: true

module Renalware
  describe System::Country do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:alpha2)
      is_expected.to validate_presence_of(:alpha3)
    end
  end
end
