module Renalware
  module Medications
    describe PrescriptionBatchRenewalPolicy, type: :policy do
      include PolicySpecHelper

      let(:super_admin) { user_double_with_role(%i(superadmin hd_prescriber)) }
      let(:clinician) { user_double_with_role(%i(clinician)) }
      let(:clinician_hd_prescriber) { user_double_with_role(%i(clinician hd_prescriber)) }
      let(:admin_hd_prescriber) { user_double_with_role(%i(admin hd_prescriber)) }
      let(:super_admin_hd_prescriber) { user_double_with_role(%i(superadmin hd_prescriber)) }

      def enforce_hd_prescriber_flag(enforce: true)
        create(:role, :hd_prescriber, enforce: enforce)
      end

      subject { described_class }

      %i(new? create?).each do |permission|
        permissions permission do
          context "when auto_terminate_hd_prescriptions_after_period is not present" do
            before do
              allow(Renalware.config)
                .to receive(:auto_terminate_hd_prescriptions_after_period)
                .and_return(nil)
            end

            context "when hd_prescriber role not enforced" do
              it { is_expected.not_to permit(super_admin, nil) }
              it { is_expected.not_to permit(super_admin_hd_prescriber, nil) }
              it { is_expected.not_to permit(clinician, nil) }
              it { is_expected.not_to permit(clinician_hd_prescriber, nil) }
            end

            context "when hd_prescriber role is enforced" do
              before { enforce_hd_prescriber_flag }

              it { is_expected.not_to permit(super_admin, nil) }
              it { is_expected.not_to permit(super_admin_hd_prescriber, nil) }
              it { is_expected.not_to permit(clinician, nil) }
              it { is_expected.not_to permit(clinician_hd_prescriber, nil) }
            end
          end

          context "when auto_terminate_hd_prescriptions_after_period is set to a period" do
            before do
              allow(Renalware.config)
                .to receive(:auto_terminate_hd_prescriptions_after_period)
                .and_return(6.months)
            end

            context "when hd_prescriber role not enforced" do
              it { is_expected.to permit(super_admin, nil) }
              it { is_expected.to permit(clinician, nil) }
              it { is_expected.to permit(super_admin_hd_prescriber, nil) }
            end

            context "when hd_prescriber role is enforced" do
              before { enforce_hd_prescriber_flag }

              it { is_expected.to permit(super_admin, nil) }
              it { is_expected.to permit(super_admin_hd_prescriber, nil) }
              it { is_expected.to permit(clinician_hd_prescriber, nil) }
              it { is_expected.not_to permit(clinician, nil) }
            end
          end
        end
      end
    end
  end
end
