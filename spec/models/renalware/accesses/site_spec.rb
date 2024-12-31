module Renalware::Accesses
  describe Site do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:code)
      is_expected.to validate_presence_of(:name)
    end
  end
end
