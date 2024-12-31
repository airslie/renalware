module Renalware
  describe Pathology::CodeGroupMembership do
    it_behaves_like "an Accountable model"
    it :aggregate_failures do
      is_expected.to be_versioned
      is_expected.to validate_presence_of(:subgroup)
      is_expected.to validate_presence_of(:position_within_subgroup)
      is_expected.to belong_to(:code_group)
      is_expected.to belong_to(:observation_description)
    end
  end
end
