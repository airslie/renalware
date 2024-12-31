module Renalware
  describe System::Component do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:class_name)
      is_expected.to validate_presence_of(:name)
    end
  end
end
