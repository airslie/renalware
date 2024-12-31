module Renalware::PD
  describe PETResultPolicy, type: :policy do
    include PolicySpecHelper
    subject(:policy) { described_class }

    %i(edit?).each do |permission|
      permissions permission do
        it "grants access if user clinician" do
          expect(policy).to permit(user_double_with_role(:clinical))
        end
      end
    end

    %i(destroy?).each do |permission|
      permissions permission do
        it "grants access if user super_admin" do
          expect(policy).to permit(user_double_with_role(:super_admin))
        end

        it "grants access if user admin" do
          expect(policy).to permit(user_double_with_role(:admin))
        end

        it "denies access if user clinician" do
          expect(policy).not_to permit(user_double_with_role(:clinical))
        end

        it "denies access if user read_only" do
          expect(policy).not_to permit(user_double_with_role(:read_only))
        end
      end
    end
  end
end
