# frozen_string_literal: true

module Renalware::Hospitals
  describe Unit do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:hospital_centre)
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:unit_code)
      is_expected.to validate_presence_of(:renal_registry_code)
      is_expected.to validate_presence_of(:unit_type)
      is_expected.to have_many(:wards)
    end
  end
end
