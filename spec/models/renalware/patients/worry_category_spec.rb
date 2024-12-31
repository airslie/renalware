module Renalware
  module Patients
    describe WorryCategory do
      it_behaves_like "an Accountable model"
      it_behaves_like "a Paranoid model"
      it { is_expected.to validate_presence_of(:name) }
    end
  end
end
