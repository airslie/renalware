module Renalware
  module LowClearance
    describe DashboardPresenter do
      include PatientsSpecHelper
      let(:user) { create(:user) }

      describe "policy methods" do
        context "when the patient has the LowClearance modality" do
          subject { described_class.new(patient: patient) }

          let(:patient) do
            build(:low_clearance_patient).tap do |pat|
              set_modality(
                patient: pat,
                modality_description: create(:low_clearance_modality_description),
                by: user
              )
            end
          end

          it "allows adding a profile if the patient has none" do
            patient
          end
        end
      end
    end
  end
end
