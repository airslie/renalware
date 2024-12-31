module Renalware
  describe Renal::AKIAlert do
    it_behaves_like "an Accountable model"
    it :aggregate_failures do
      is_expected.to validate_presence_of(:patient)
      is_expected.to have_db_index(:hotlist)
      is_expected.to have_db_index(:action)
      is_expected.to belong_to(:action).class_name("AKIAlertAction")
      is_expected.to belong_to(:hospital_ward)
      is_expected.to belong_to(:patient).touch(true)
      is_expected.to be_versioned
    end
  end
end
