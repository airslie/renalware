module Renalware::Patients
  describe Practice do
    it :aggregate_failures do
      is_expected.to validate_presence_of :name
      is_expected.to validate_presence_of :address
      is_expected.to validate_presence_of :code
      is_expected.to have_many(:practice_memberships)
      is_expected.to have_many(:primary_care_physicians).through(:practice_memberships)
    end
  end
end
