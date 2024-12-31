module Renalware
  module HD
    describe Session do
      it_behaves_like "an Accountable model"
      it_behaves_like "a Paranoid model"
      it :aggregate_failures do
        is_expected.to be_versioned
        is_expected.to have_many(:prescription_administrations)
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to belong_to(:dialysate)
        is_expected.to belong_to(:station)
        is_expected.to have_many(:patient_group_directions)
        is_expected.to have_many(:session_patient_group_directions)
      end
    end
  end
end
