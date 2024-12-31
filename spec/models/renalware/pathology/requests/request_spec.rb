module Renalware
  describe Pathology::Requests::Request do
    it_behaves_like "an Accountable model"
    it :aggregate_failures do
      is_expected.to belong_to(:patient).touch(true)
      is_expected.to belong_to(:clinic)
      is_expected.to belong_to(:consultant)
      is_expected.to have_and_belong_to_many(:request_descriptions)
      is_expected.to have_and_belong_to_many(:patient_rules)
      is_expected.to validate_presence_of(:patient)
      is_expected.to validate_presence_of(:clinic)
      is_expected.to validate_presence_of(:consultant)
      is_expected.to validate_presence_of(:template)
    end
  end
end
