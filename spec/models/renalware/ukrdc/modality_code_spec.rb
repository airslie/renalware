module Renalware
  describe UKRDC::ModalityCode do
    it :aggregate_failures do
      is_expected.to respond_to(:description)
      is_expected.to respond_to(:qbl_code)
      is_expected.to respond_to(:txt_code)
    end
  end
end
