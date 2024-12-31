module Renalware
  module HD
    describe PrescriptionAdministrationPolicy, type: :policy do
      subject(:policy) { described_class }

      let(:clinical_user) { FactoryBot.create(:user, :clinical) }
      let(:admin_user) { FactoryBot.create(:user, :admin) }
      let(:super_admin_user) { FactoryBot.create(:user, :super_admin) }
      let(:prescription_administration) { FactoryBot.build(:hd_prescription_administration) }

      %i(destroy?).each do |permission|
        permissions permission do
          it { expect(policy).not_to permit(clinical_user, prescription_administration) }
          it { expect(policy).to permit(admin_user, prescription_administration) }
          it { expect(policy).to permit(super_admin_user, prescription_administration) }
        end
      end
    end
  end
end
