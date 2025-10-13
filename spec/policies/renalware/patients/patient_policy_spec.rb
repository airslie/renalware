module Renalware
  module Patients
    describe PatientPolicy, type: :policy do
      include PolicySpecHelper

      subject { described_class }
      let(:guest)       { user_double_with_role(:read_only) }
      let(:clinician)   { user_double_with_role(:clinical) }
      let(:admin)       { user_double_with_role(:admin) }
      let(:super_admin) { user_double_with_role(:super_admin) }
      let(:patient)     { instance_double(Patient, persisted?: true) }

      permissions :show?, :index? do
        it do
          is_expected.to permit(clinician, patient)
          is_expected.to permit(admin, patient)
          is_expected.to permit(super_admin, patient)
        end
      end

      context "when disable_inputs_controlled_by_demographics_feed is true" do
        before do
          allow(Renalware.config)
            .to receive(:disable_inputs_controlled_by_demographics_feed).and_return(true)
        end

        permissions :new?, :create? do
          it do
            is_expected.not_to permit(guest, patient)
            is_expected.not_to permit(clinician, patient)
            is_expected.not_to permit(admin, patient)
            is_expected.to permit(super_admin, patient)
          end
        end

        permissions :edit?, :update? do
          it do
            is_expected.not_to permit(guest, patient)
            is_expected.to permit(clinician, patient)
            is_expected.to permit(admin, patient)
            is_expected.to permit(super_admin, patient)
          end
        end
      end
    end
  end
end
