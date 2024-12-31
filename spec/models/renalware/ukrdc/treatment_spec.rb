module Renalware
  describe UKRDC::Treatment do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:patient)
      is_expected.to validate_presence_of(:modality_code)
    end
  end
end
