module Renalware
  module LowClearance
    describe ProfilePolicy, type: :policy do
      include PatientsSpecHelper
      include PolicySpecHelper
      subject { described_class }

      let(:clinician) { user_double_with_role(:clinical) }
      let(:user) { create(:user) }
      let(:patient) { create(:low_clearance_patient) }
      let(:profile) { create(:low_clearance_profile, patient: patient, by: user) }

      permissions :edit? do
        context "when the patient has the LowClearance modality" do
          before do
            set_modality(
              patient: patient,
              modality_description: create(:low_clearance_modality_description),
              by: user
            )
          end

          context "when the patient has a profile" do
            it { is_expected.to permit(clinician, profile) }
          end

          context "when the patient has no profile yet" do
            it { is_expected.not_to permit(clinician, nil) }
          end
        end

        context "when the does not have the LowClearance modality" do
          it { is_expected.not_to permit(clinician, profile) }
        end
      end
    end
  end
end
