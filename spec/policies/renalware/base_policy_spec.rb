module Renalware
  describe BasePolicy, type: :policy do
    include PolicySpecHelper

    let(:super_admin) { user_double_with_role(:super_admin) }
    let(:admin) { user_double_with_role(:admin) }
    let(:clinician) { user_double_with_role(:clinical) }

    it "checks and defines permissions for super admins" do
      policy = described_class.new(super_admin, User.new)
      expect(policy.create?).to be true

      policy = described_class.new(super_admin, Drugs::Type.new)
      expect(policy.create?).to be true
    end

    it "checks and defines permissions for admins" do
      policy = described_class.new(admin, Role.new)
      expect(policy.create?).to be false

      policy = described_class.new(admin, Drugs::Type.new)
      expect(policy.create?).to be true
    end

    it "checks and defines permissions for clinicians" do
      policy = described_class.new(clinician, User.new)
      expect(policy.create?).to be false

      policy = described_class.new(clinician, Drugs::Type.new)
      expect(policy.create?).to be false

      policy = described_class.new(clinician, Patient.new)
      expect(policy.create?).to be true
    end
  end
end
