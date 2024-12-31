module Renalware::Problems
  describe Problem do
    it_behaves_like "a Paranoid model"
    it_behaves_like "an Accountable model"
    it :aggregate_failures do
      is_expected.to belong_to(:patient).touch(true)
      is_expected.to validate_presence_of :patient
      is_expected.to validate_presence_of :description
      is_expected.to be_versioned
    end
  end
end
