module Renalware::Patients
  describe PracticeMembership do
    it :aggregate_failures do
      is_expected.to belong_to(:practice)
      is_expected.to belong_to(:primary_care_physician)
    end

    it_behaves_like "a Paranoid model"
  end
end
