module Renalware::Problems::RaDaR
  describe Diagnosis do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to have_db_index(%i(cohort_id name)).unique }
    it { is_expected.to belong_to(:cohort) }
  end
end
