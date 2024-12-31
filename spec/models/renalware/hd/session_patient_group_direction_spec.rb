module Renalware
  module HD
    describe SessionPatientGroupDirection do
      it { is_expected.to belong_to(:session) }
      it { is_expected.to belong_to(:patient_group_direction) }
      it { is_expected.to validate_presence_of(:session) }
      it { is_expected.to validate_presence_of(:patient_group_direction) }
    end
  end
end
