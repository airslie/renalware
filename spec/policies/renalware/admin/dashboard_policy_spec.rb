module Renalware
  describe Admin::DashboardPolicy, type: :policy do
    include PolicySpecHelper

    %i(admin super_admin devops).each do |role|
      it "permits users with the #{role} role" do
        policy = described_class.new(user_double_with_role(role), :"renalware/admin/dashboard")
        expect(policy.show?).to be(true)
      end
    end

    %i(clinical read_only prescriber hd_prescriber).each do |role|
      it "denies users with the #{role} role" do
        policy = described_class.new(user_double_with_role(role), :"renalware/admin/dashboard")
        expect(policy.show?).to be(false)
      end
    end

    it "denies users with no roles" do
      policy = described_class.new(user_double_with_role([]), :"renalware/admin/dashboard")
      expect(policy.show?).to be(false)
    end
  end
end
