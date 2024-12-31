module Renalware
  describe PatientDocument, type: :model do
    it :aggregate_failures do
      is_expected.to respond_to(:history)
      is_expected.to respond_to(:referral)
      is_expected.to respond_to(:psychosocial)
      is_expected.to respond_to(:diabetes)
    end
  end
end
