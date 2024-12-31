module Renalware::HD
  describe Dialyser do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:group)
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_numericality_of(:membrane_surface_area)
      is_expected.to validate_numericality_of(:membrane_surface_area_coefficient_k0a)
    end
  end
end
