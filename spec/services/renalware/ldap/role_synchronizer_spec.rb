module Renalware
  module Ldap
    describe RoleSynchronizer do
      subject(:synchronizer) { described_class.new }

      let(:ldap_connection) { instance_double(Connection) }
      let!(:clinical_role) { create(:role, :clinical) }
      let!(:readonly_role) { create(:role, :read_only) }
      let!(:prescriber_role) { create(:role, :prescriber) }
      let!(:hd_prescriber_role) { create(:role, :hd_prescriber) }
      let!(:admin_role) { create(:role, :admin) }
      let!(:super_admin_role) { create(:role, :super_admin) }
      let!(:devops_role) { create(:role, :devops) }

      before do
        allow(Renalware.config).to receive(:ldap_authentication).and_return(true)
        allow(Connection).to receive(:new).and_return(ldap_connection)
      end

      describe "#assign_role" do
        let(:user) { build(:user, username: "testuser") }

        context "when LDAP is disabled" do
          before do
            allow(Renalware.config).to receive(:ldap_authentication).and_return(false)
          end

          it "does not assign any role" do
            expect { synchronizer.assign_role(user) }.not_to change { user.roles.count }
          end
        end

        context "when user is in renalware LDAP group" do
          before do
            allow(ldap_connection).to receive(:user_in_group?) do |group|
              group == Renalware.config.ldap_clinical_group
            end
          end

          it "assigns clinical role" do
            synchronizer.assign_role(user)

            expect(user.roles).to include(clinical_role)
          end
        end

        context "when user is in renalware-readonly LDAP group" do
          before do
            allow(ldap_connection).to receive(:user_in_group?) do |group|
              group == Renalware.config.ldap_readonly_group
            end
          end

          it "assigns read_only role" do
            synchronizer.assign_role(user)

            expect(user.roles).to include(readonly_role)
          end
        end

        context "when user is not in any valid LDAP group" do
          before do
            allow(ldap_connection).to receive(:user_in_group?).and_return(false)
          end

          it "does not assign any role" do
            expect { synchronizer.assign_role(user) }.not_to change { user.roles.count }
          end
        end
      end

      describe "#synchronize_roles" do
        context "when LDAP is disabled" do
          it "does not modify roles" do
            allow(Renalware.config).to receive(:ldap_authentication).and_return(false)
            user = create(:user, role: nil, roles: [clinical_role])

            expect { synchronizer.synchronize_roles(user) }
              .not_to change { user.roles.reload.to_a }
          end
        end

        context "when user is in renalware LDAP group" do
          before do
            allow(ldap_connection).to receive(:user_in_group?) do |group|
              group == Renalware.config.ldap_clinical_group
            end
          end

          context "when user currently has read_only role" do
            it "upgrades to clinical role" do
              user = create(:user, role: nil, roles: [readonly_role])

              synchronizer.synchronize_roles(user)

              expect(user.roles.reload).to contain_exactly(clinical_role)
            end

            it "preserves prescriber roles during upgrade" do
              user = create(:user, role: nil,
                                   roles: [readonly_role, prescriber_role, hd_prescriber_role])

              synchronizer.synchronize_roles(user)

              expect(user.roles.reload).to contain_exactly(
                clinical_role,
                prescriber_role,
                hd_prescriber_role
              )
            end
          end

          context "when user already has clinical role" do
            it "does not modify roles" do
              user = create(:user, role: nil, roles: [clinical_role, prescriber_role],
                                   updated_at: 2.minutes.ago)
              initial_updated_at = user.reload.updated_at

              synchronizer.synchronize_roles(user)

              expect(user.roles.reload).to contain_exactly(clinical_role, prescriber_role)
              expect(user.reload.updated_at).to eq(initial_updated_at)
            end
          end
        end

        context "when user is in renalware-readonly LDAP group" do
          before do
            allow(ldap_connection).to receive(:user_in_group?) do |group|
              group == Renalware.config.ldap_readonly_group
            end
          end

          context "when user currently has clinical role" do
            it "downgrades to read_only role" do
              user = create(:user, role: nil, roles: [clinical_role])

              synchronizer.synchronize_roles(user)

              expect(user.roles.reload).to contain_exactly(readonly_role)
            end

            it "preserves prescriber roles during downgrade" do
              user = create(:user, role: nil,
                                   roles: [clinical_role, prescriber_role, hd_prescriber_role])

              synchronizer.synchronize_roles(user)

              expect(user.roles.reload).to contain_exactly(
                readonly_role,
                prescriber_role,
                hd_prescriber_role
              )
            end
          end

          context "when user already has read_only role" do
            it "does not modify roles" do
              user = create(:user, role: nil, roles: [readonly_role, prescriber_role],
                                   updated_at: 2.minutes.ago)
              initial_updated_at = user.reload.updated_at

              synchronizer.synchronize_roles(user)

              expect(user.roles.reload).to contain_exactly(readonly_role, prescriber_role)
              expect(user.reload.updated_at).to eq(initial_updated_at)
            end
          end
        end

        context "when user is not in a valid LDAP group" do
          let(:username) { "renalwareuser-1" }
          let(:roles) { [clinical_role] }
          let(:user) do
            # Create user first with LDAP returning true, then change the stub
            # to simulate the user being removed from the LDAP group
            allow(ldap_connection).to receive(:user_in_group?).and_return(true)
            u = create(:user, role: nil, roles:, approved: true, username:,
                              updated_at: 2.minutes.ago)
            # Now simulate user no longer in any valid LDAP group
            allow(ldap_connection).to receive(:user_in_group?).and_return(false)
            u
          end

          it "removes LDAP roles but keeps user approved" do
            synchronizer.synchronize_roles(user)

            expect(user.reload).to be_approved
            expect(user.roles).to be_empty
          end
        end

        context "when user has admin-level roles" do
          it "does not modify super_admin role" do
            # Allow creation first
            allow(ldap_connection).to receive(:user_in_group?).and_return(true)
            user = create(:user, role: nil, roles: [super_admin_role], username: "superadmin-1")
            # Now simulate no group membership
            allow(ldap_connection).to receive(:user_in_group?).and_return(false)

            synchronizer.synchronize_roles(user)

            expect(user.roles.reload).to contain_exactly(super_admin_role)
          end

          it "does not modify admin role" do
            # Allow creation first
            allow(ldap_connection).to receive(:user_in_group?).and_return(true)
            user = create(:user, role: nil, roles: [admin_role], username: "admin-1")
            # Now simulate no group membership
            allow(ldap_connection).to receive(:user_in_group?).and_return(false)

            synchronizer.synchronize_roles(user)

            expect(user.roles.reload).to contain_exactly(admin_role)
          end

          it "does not modify devops role" do
            # Allow creation first
            allow(ldap_connection).to receive(:user_in_group?).and_return(true)
            user = create(:user, role: nil, roles: [devops_role], username: "devops-1")
            # Now simulate no group membership
            allow(ldap_connection).to receive(:user_in_group?).and_return(false)

            synchronizer.synchronize_roles(user)

            expect(user.roles.reload).to contain_exactly(devops_role)
          end
        end

        context "when LDAP group check fails" do
          it "raises the LDAP error" do
            # Allow creation first
            allow(ldap_connection).to receive(:user_in_group?).and_return(true)
            user = create(:user, role: nil, roles: [clinical_role], approved: true)
            # Now simulate LDAP error
            allow(ldap_connection).to receive(:user_in_group?)
              .and_raise(Error.new("LDAP error"))

            expect { synchronizer.synchronize_roles(user) }.to raise_error(Error)
          end
        end
      end

      describe "#determine_role" do
        let(:user) { build(:user, username: "testuser") }

        context "when user is in renalware LDAP group" do
          before do
            allow(ldap_connection).to receive(:user_in_group?) do |group|
              group == Renalware.config.ldap_clinical_group
            end
          end

          it "returns :clinical" do
            expect(synchronizer.determine_role(user)).to eq(:clinical)
          end
        end

        context "when user is in renalware-readonly LDAP group" do
          before do
            allow(ldap_connection).to receive(:user_in_group?) do |group|
              group == Renalware.config.ldap_readonly_group
            end
          end

          it "returns :read_only" do
            expect(synchronizer.determine_role(user)).to eq(:read_only)
          end
        end

        context "when user is not in any valid LDAP group" do
          before do
            allow(ldap_connection).to receive(:user_in_group?).and_return(false)
          end

          it "returns nil" do
            expect(synchronizer.determine_role(user)).to be_nil
          end
        end
      end

      describe "#admin_level_user?" do
        it "returns true for super_admin role" do
          allow(ldap_connection).to receive(:user_in_group?).and_return(true)
          user = create(:user, role: nil, roles: [super_admin_role])

          expect(synchronizer.admin_level_user?(user)).to be(true)
        end

        it "returns true for admin role" do
          allow(ldap_connection).to receive(:user_in_group?).and_return(true)
          user = create(:user, role: nil, roles: [admin_role])

          expect(synchronizer.admin_level_user?(user)).to be(true)
        end

        it "returns true for devops role" do
          allow(ldap_connection).to receive(:user_in_group?).and_return(true)
          user = create(:user, role: nil, roles: [devops_role])

          expect(synchronizer.admin_level_user?(user)).to be(true)
        end

        it "returns false for clinical role" do
          allow(ldap_connection).to receive(:user_in_group?) do |group|
            group == Renalware.config.ldap_clinical_group
          end
          user = create(:user, role: nil, roles: [clinical_role])

          expect(synchronizer.admin_level_user?(user)).to be(false)
        end

        it "returns false for read_only role" do
          allow(ldap_connection).to receive(:user_in_group?) do |group|
            group == Renalware.config.ldap_readonly_group
          end
          user = create(:user, role: nil, roles: [readonly_role])

          expect(synchronizer.admin_level_user?(user)).to be(false)
        end

        it "returns false for user with no roles" do
          allow(ldap_connection).to receive(:user_in_group?).and_return(true)
          user = create(:user, role: nil)
          user.roles.clear

          expect(synchronizer.admin_level_user?(user)).to be(false)
        end
      end
    end
  end
end
