module Renalware
  describe Pathology::CalculationSource do
    it { is_expected.to belong_to(:calculated_observation) }
    it { is_expected.to belong_to(:source_observation) }

    it {
      is_expected.to have_db_index(%i(calculated_observation_id
                                      source_observation_id)).unique(true)
    }

    it { is_expected.to validate_presence_of(:calculated_observation) }
    it { is_expected.to validate_presence_of(:source_observation) }
  end
end
