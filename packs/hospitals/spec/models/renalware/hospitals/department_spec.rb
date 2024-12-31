module Renalware::Hospitals
  describe Department do
    it_behaves_like "a Paranoid model"

    it :aggregate_failures do
      is_expected.to belong_to(:hospital_centre)
      is_expected.to validate_presence_of(:hospital_centre)
      is_expected.to validate_presence_of(:name)
    end
  end
end
