module Renalware
  module Patients
    describe Abridgement do
      it :aggregate_failures do
        is_expected.to validate_presence_of(:hospital_number)
        is_expected.to validate_presence_of(:given_name)
        is_expected.to validate_presence_of(:family_name)
      end
    end
  end
end
