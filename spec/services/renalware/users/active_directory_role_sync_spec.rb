module Renalware
  module Users
    describe ActiveDirectoryRoleSync do
      let!(:clinical_role) { create(:role, :clinical, ad_role_name: "renalware-clinical") }
      let!(:readonly_role) { create(:role, :read_only, ad_role_name: "renalware-readonly") }
      let!(:prescriber_role) { create(:role, :prescriber) }

      it "adds and removes only AD-managed roles" do
        user = create(:user, :minimal, roles: [readonly_role, prescriber_role])

        described_class.new(
          user:,
          ad_roles: ["CN=Renalware-Clinical,OU=Groups,DC=example,DC=com"]
        ).call

        expect(user.roles.reload).to contain_exactly(clinical_role, prescriber_role)
      end

      it "treats role names case-insensitively" do
        user = create(:user, :minimal, roles: [clinical_role, prescriber_role])

        described_class.new(user:, ad_roles: "RENALWARE-READONLY").call

        expect(user.roles.reload).to contain_exactly(readonly_role, prescriber_role)
      end

      it "removes managed roles when LDAP provides none" do
        user = create(:user, :minimal, roles: [clinical_role, prescriber_role])

        described_class.new(user:, ad_roles: nil).call

        expect(user.roles.reload).to contain_exactly(prescriber_role)
      end

      it "keeps only the clinical access role when both clinical and readonly are present" do
        user = create(:user, :minimal, roles: [prescriber_role])

        described_class.new(
          user:,
          ad_roles: [
            "CN=Renalware-Clinical,OU=Groups,DC=example,DC=com",
            "CN=Renalware-Readonly,OU=Groups,DC=example,DC=com"
          ]
        ).call

        expect(user.roles.reload).to contain_exactly(clinical_role, prescriber_role)
      end
    end
  end
end
