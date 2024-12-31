module Renalware::Messaging::Internal
  describe Recipient do
    it :aggregate_failures do
      is_expected.to have_many(:messages).through(:receipts)
      is_expected.to have_many(:receipts).class_name("Renalware::Messaging::Internal::Receipt")
    end
  end
end
