module Renalware
  module Medications
    describe PrescriptionPolicy, type: :policy do
      include PolicySpecHelper

      def enforce_prescriber_flag(enforce: true)
        create(:role, :prescriber, enforce: enforce)
      end

      def enforce_hd_prescriber_flag(enforce: true)
        create(:role, :hd_prescriber, enforce: enforce)
      end

      subject { described_class }

      let(:prescription) { Prescription.new }

      %i(new? create? edit? update? destroy?).each do |permission|
        permissions permission do
          context "when user has prescriber role but no clinical/admin/superadmin/devops" do
            let(:user) { user_double_with_role(%i(prescriber)) }

            it { is_expected.not_to permit(user, prescription) }
          end

          context "when user has prescriber role but only the readonly role" do
            let(:user) { user_double_with_role(%i(prescriber read_only)) }

            it { is_expected.not_to permit(user, prescription) }
          end
        end

        permissions permission do
          context "when user has prescriber role" do
            let(:user) { user_double_with_role(%i(clinical prescriber)) }

            it { is_expected.to permit(user, prescription) }
          end

          context "when user does not have the prescriber role" do
            let(:user) { user_double_with_role(%i(clinical)) }

            context "when Renalware.config is set to enforce the prescriber flag" do
              before { enforce_prescriber_flag }

              it { is_expected.not_to permit(user, prescription) }
            end

            context "when Renalware.config is not enforcing the prescriber flag" do
              before { enforce_prescriber_flag(enforce: false) }

              it { is_expected.to permit(user, prescription) }
            end
          end
        end
      end

      describe "changing an HD prescription when prescriber flag is enforced" do
        before { enforce_hd_prescriber_flag }

        context "when a clinician does not have hd_prescriber role" do
          let(:prescription) { Prescription.new(administer_on_hd: true) }

          %i(edit? update? destroy?).each do |permission|
            let(:user) { user_double_with_role(%i(prescriber clinical)) }

            permissions permission do
              it { is_expected.not_to permit(user, prescription) }
            end
          end
        end

        context "when a clinician has the hd_prescriber role" do
          let(:prescription) { Prescription.new(administer_on_hd: true) }

          %i(edit? update? destroy?).each do |permission|
            let(:user) { user_double_with_role(%i(hd_prescriber clinical)) }

            permissions permission do
              it { is_expected.to permit(user, prescription) }
            end
          end
        end
      end

      describe "changing an HD prescription when prescriber flag not enforced" do
        before { enforce_prescriber_flag(enforce: false) }

        describe "a clinician with just the prescriber role can amend the prescription" do
          let(:prescription) { Prescription.new(administer_on_hd: true) }

          %i(edit? update? destroy?).each do |permission|
            let(:user) { user_double_with_role(%i(prescriber clinical)) }

            permissions permission do
              it { is_expected.to permit(user, prescription) }
            end
          end
        end
      end
    end
  end
end
