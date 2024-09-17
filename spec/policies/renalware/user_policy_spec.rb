# frozen_string_literal: true

module Renalware
  describe UserPolicy, type: :policy do
    include PolicySpecHelper
    subject(:policy) { described_class }

    let(:admin) { user_double_with_role(:admin) }
    let(:super_admin) { user_double_with_role(:super_admin) }
    let(:clinician) { user_double_with_role(:clinical) }
    let(:other_clinician) { create(:user, :clinical) }

    permissions :update? do
      it "permits an admin user to update other users" do
        expect(policy).to permit(admin, clinician)
      end

      it "does not permit the user to update themselves" do
        expect(policy).not_to permit(admin, admin)
      end

      it "does not permit a non-admin to update another user" do
        expect(policy).not_to permit(clinician, other_clinician)
      end
    end

    describe "assign_role?" do
      %i(admin super_admin devops clinician).each do |role|
        it "does not allow a clinician to assign the #{role} role" do
          policy = described_class.new(clinician, other_clinician)
          expect(policy.assign_role?(Role.new(name: role))).to be(false)
        end
      end

      %i(admin super_admin devops).each do |role|
        it "does not allow an admin to assign the #{role} role" do
          policy = described_class.new(admin, clinician)
          expect(policy.assign_role?(Role.new(name: role))).to be(false)
        end
      end

      %i(super_admin devops).each do |role|
        it "does not allow a super admin to assign the #{role} role" do
          policy = described_class.new(super_admin, clinician)
          expect(policy.assign_role?(Role.new(name: role))).to be(false)
        end
      end

      it "allows a superadmin to assign the admin role" do
        policy = described_class.new(super_admin, clinician)
        expect(policy.assign_role?(Role.new(name: :admin))).to be(true)
      end
    end
  end
end
