require_relative "../concerns/personable"

module Renalware
  describe User do
    it_behaves_like "Personable"

    it :aggregate_failures do
      is_expected.to validate_presence_of(:given_name)
      is_expected.to validate_presence_of(:family_name)
      is_expected.to respond_to(:authentication_token)
      is_expected.not_to be_versioned
    end

    describe "#generate_new_authentication_token" do
      it "creates a new token and saves it to the user" do
        user = create(:user)
        token = user.generate_new_authentication_token!
        expect(token.length).to be >= 20
        expect(user.reload.authentication_token).to eq(token)
      end
    end

    describe "validation" do
      it :aggregate_failures do
        is_expected.to validate_presence_of(:given_name)
        is_expected.to validate_presence_of(:family_name)
      end

      context "when #with_extended_validation is true" do
        subject { described_class.new(with_extended_validation: true) }

        it :aggregate_failures do
          is_expected.to validate_presence_of(:professional_position).on(:update)
          is_expected.to validate_presence_of(:signature).on(:update)
        end
      end

      context "when #with_extended_validation is false" do
        subject { described_class.new(with_extended_validation: false) }

        it :aggregate_failures do
          is_expected.not_to validate_presence_of(:professional_position).on(:update)
          is_expected.not_to validate_presence_of(:signature).on(:update)
        end
      end
    end

    describe "class" do
      it "includes Deviseable to authenticate using Devise" do
        expect(described_class.ancestors).to include(Deviseable)
        arr = %i(expirable database_authenticatable rememberable registerable
                 validatable trackable timeoutable recoverable lockable)
        expect(described_class.devise_modules).to match_array(arr)
      end
    end

    it "is unapproved by default" do
      expect(build(:user, :unapproved)).not_to be_approved
    end

    describe "#active_for_authentication?" do
      it "returns false for unapproved users" do
        user = build(:user, approved: false)
        expect(user.active_for_authentication?).to be(false)
      end

      it "returns true for approved users" do
        user = build(:user, approved: true)
        expect(user.active_for_authentication?).to be(true)
      end

      it "returns false for banned users" do
        user = build(:user, approved: true, banned: true)
        expect(user.active_for_authentication?).to be(false)
      end
    end

    describe "read_only?" do
      it "denotes a user with the read_only role" do
        expect(create(:user, :read_only)).to have_role(:read_only)
      end
    end

    describe "#professional_signature" do
      subject(:user) { described_class.new(given_name: "X", family_name: "Y") }

      context "when there is no professional_position" do
        context "when there is no signature" do
          it "returns the full name only" do
            expect(user.professional_signature).to eq "X Y"
          end
        end

        context "when there is a signature" do
          it "returns the signature only" do
            user.signature = "Dr X Y"
            expect(user.professional_signature).to eq "Dr X Y"
          end
        end
      end

      context "when there is a professional_position" do
        context "when there is no signature" do
          it "returns the signature and professional_position" do
            user.professional_position = "Consultant"
            expect(user.professional_signature).to eq "X Y (Consultant)"
          end
        end

        context "when there is a signature" do
          it "returns the signature and professional_position" do
            user.signature = "Dr X Y"
            user.professional_position = "Consultant"
            expect(user.professional_signature).to eq "Dr X Y (Consultant)"
          end
        end
      end
    end

    describe "scopes" do
      describe "ordered" do
        let!(:visibleB) { create(:user, family_name: "B", given_name: "aa") }
        let!(:visibleA) { create(:user, family_name: "A", given_name: "bb") }

        before { create(:user, hidden: true) }

        it "retrieves only visible users in the correct order" do
          expect(described_class.ordered).to eq [visibleA, visibleB]
        end
      end

      describe "active" do
        let!(:activeB) { create(:user, family_name: "B", given_name: "aa") }
        let!(:activeA) { create(:user, family_name: "A", given_name: "bb") }

        before do
          create(:user, hidden: true)
          create(:user, banned: true)
          create(:user, last_activity_at: 90.days.ago)
          create(:user, last_activity_at: nil)
        end

        it "retreives users that are not hidden, inactive or banned" do
          expect(described_class.active).to eq [activeA, activeB]
        end
      end

      describe "unapproved" do
        it "retrieves unapproved users" do
          approved = create(:user)
          unapproved = create(:user, :unapproved)

          actual = described_class.unapproved
          expect(actual.size).to eq(1)
          expect(actual).to include(unapproved)
          expect(actual).not_to include(approved)
        end
      end

      describe "inactive" do
        it "retrieves inactive users" do
          create(:user, last_activity_at: 1.minute.ago)
          inactive = create(:user, last_activity_at: 90.days.ago)
          never_used = create(:user, last_activity_at: nil, created_at: 90.days.ago)

          expect(described_class.inactive).to contain_exactly(inactive, never_used)
        end
      end

      describe "author" do
        it "retrieves users with a signature" do
          author = create(:user, signature: "Dr D.O. Good")
          unsigned = create(:user, signature: nil)

          actual = described_class.author
          expect(actual).to include(author)
          expect(actual).not_to include(unsigned)
        end
      end

      describe "consultants" do
        it "retrieves only users wih the consultant boolean flag set to true" do
          consultant = create(:user, consultant: true)
          create(:user)

          consultants = described_class.consultants

          expect(consultants).to eq([consultant])
        end
      end

      describe "#picklist scope" do
        it "omits hidden users" do
          create(:user, hidden: true)
          user = create(:user, hidden: false)
          expect(described_class.picklist).to eq([user])
        end
      end
    end

    describe "#assign_default_role_if_needed" do
      before do
        create(:role, :clinical)
        create(:role, :read_only)
      end

      context "when user already has roles" do
        it "does not assign any new roles" do
          user = build(:user, role: nil)
          clinical_role = Role.find_by!(name: :clinical)
          user.roles << clinical_role
          user.save!
          initial_role_count = user.roles.count

          user.send(:assign_default_role_if_needed)

          expect(user.roles.count).to eq(initial_role_count)
        end
      end

      context "when LDAP authentication is disabled" do
        before do
          allow(Renalware.config).to receive(:ldap_authentication).and_return(false)
        end

        it "assigns clinical role by default" do
          user = build(:user)
          user.save!

          clinical_role = Role.find_by!(name: :clinical)
          expect(user.roles).to contain_exactly(clinical_role)
        end
      end

      context "when LDAP authentication is enabled" do
        before do
          allow(Renalware.config).to receive(:ldap_authentication).and_return(true)
        end

        context "when user is in renalware LDAP group" do
          it "assigns clinical role and approves user" do
            user = build(:user, role: nil)
            allow(user).to receive_messages(in_renalware_group?: true,
                                            in_renalware_readonly_group?: false)
            user.save!

            clinical_role = Role.find_by!(name: :clinical)
            expect(user.roles).to contain_exactly(clinical_role)
            expect(user).to be_approved
          end
        end

        context "when user is in renalware-readonly LDAP group" do
          it "assigns read_only role and approves user" do
            user = build(:user, role: nil)
            allow(user).to receive_messages(in_renalware_group?: false,
                                            in_renalware_readonly_group?: true)
            user.save!

            readonly_role = Role.find_by!(name: :read_only)
            expect(user.roles).to contain_exactly(readonly_role)
            expect(user).to be_approved
          end
        end

        context "when user is not in any valid LDAP group" do
          it "prevents user creation" do
            user = build(:user, role: nil, approved: false)
            allow(user).to receive_messages(in_renalware_group?: false,
                                            in_renalware_readonly_group?: false)

            result = user.save

            expect(result).to be false
            expect(user).to be_new_record
            expect(user.errors[:base]).to include(
              "User must be in a valid LDAP group (renalware or renalware-readonly)"
            )
          end
        end

        context "when LDAP group check fails" do
          it "prevents user creation" do
            user = build(:user, role: nil, approved: false)
            allow(user).to receive_messages(in_renalware_group?: false,
                                            in_renalware_readonly_group?: false)
            allow(Rails.logger).to receive(:error)

            result = user.save

            expect(result).to be false
            expect(user).to be_new_record
          end
        end
      end
    end

    describe "#ldap_before_save" do
      let(:user) { build(:user, username: "testuser") }
      let(:ldap_adapter) { instance_double(Ldap::Adapter) }

      before do
        allow(Renalware.config).to receive(:ldap_authentication).and_return(true)
        allow(Ldap::Adapter).to receive(:new).and_return(ldap_adapter)
        allow(ldap_adapter).to receive(:param)
          .with(user.username, "sn")
          .and_return("Doe")
        allow(ldap_adapter).to receive(:param)
          .with(user.username, "mail")
          .and_return("john.doe@example.com")
        allow(user).to receive(:in_valid_ldap_group?).and_return(true)
      end

      context "when givenName is present" do
        it "sets given_name from givenName attribute" do
          allow(ldap_adapter).to receive(:param)
            .with(user.username, "givenName")
            .and_return("John")
          allow(user).to receive(:in_valid_ldap_group?).and_return(true)

          user.ldap_before_save

          expect(user.given_name).to eq("John")
        end
      end

      context "when givenName is nil" do
        it "falls back to cn attribute" do
          allow(ldap_adapter).to receive(:param)
            .with(user.username, "givenName")
            .and_return(nil)
          allow(ldap_adapter).to receive(:param)
            .with(user.username, "cn")
            .and_return("John Doe")
          allow(user).to receive(:in_valid_ldap_group?).and_return(true)

          user.ldap_before_save

          expect(user.given_name).to eq("John Doe")
        end
      end

      context "when ldap_auto_approve_users is enabled" do
        it "sets approved to true when user is in valid LDAP group" do
          allow(Renalware.config).to receive(:ldap_auto_approve_users).and_return(true)
          allow(ldap_adapter).to receive(:param)
            .with(user.username, "givenName")
            .and_return("John")
          allow(user).to receive(:in_valid_ldap_group?).and_return(true)

          user.ldap_before_save

          expect(user.approved).to be(true)
        end
      end

      context "when ldap_auto_approve_users is disabled" do
        it "sets approved to false when user is in valid LDAP group" do
          allow(Renalware.config).to receive(:ldap_auto_approve_users).and_return(false)
          allow(ldap_adapter).to receive(:param)
            .with(user.username, "givenName")
            .and_return("John")
          allow(user).to receive(:in_valid_ldap_group?).and_return(true)

          user.ldap_before_save

          expect(user.approved).to be(false)
        end
      end
    end

    describe "#synchronize_ldap_roles" do
      let!(:clinical_role) { create(:role, :clinical) }
      let!(:readonly_role) { create(:role, :read_only) }
      let!(:prescriber_role) { create(:role, :prescriber) }
      let!(:hd_prescriber_role) { create(:role, :hd_prescriber) }
      let!(:admin_role) { create(:role, :admin) }
      let!(:super_admin_role) { create(:role, :super_admin) }
      let!(:devops_role) { create(:role, :devops) }
      let(:ldap_adapter) { instance_double(Ldap::Adapter) }

      before do
        allow(Renalware.config).to receive(:ldap_authentication).and_return(true)
        allow(Ldap::Adapter).to receive(:new).and_return(ldap_adapter)
      end

      context "when LDAP is disabled" do
        it "does not modify roles" do
          allow(Renalware.config).to receive(:ldap_authentication).and_return(false)
          user = create(:user, role: nil, roles: [clinical_role])

          expect { user.synchronize_ldap_roles }.not_to change { user.roles.reload.to_a }
        end
      end

      context "when user is in renalware LDAP group" do
        before do
          allow(ldap_adapter).to receive(:user_in_group?) do |_username, group|
            group == Renalware.config.ldap_clinical_group
          end
        end

        context "when user currently has read_only role" do
          it "upgrades to clinical role" do
            user = create(:user, role: nil, roles: [readonly_role])

            user.synchronize_ldap_roles

            expect(user.roles.reload).to contain_exactly(clinical_role)
          end

          it "preserves prescriber roles during upgrade" do
            user = create(:user, role: nil,
                                 roles: [readonly_role, prescriber_role, hd_prescriber_role])

            user.synchronize_ldap_roles

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

            user.synchronize_ldap_roles

            expect(user.roles.reload).to contain_exactly(clinical_role, prescriber_role)
            expect(user.reload.updated_at).to eq(initial_updated_at)
          end
        end
      end

      context "when user is in renalware-readonly LDAP group" do
        before do
          allow(ldap_adapter).to receive(:user_in_group?) do |_username, group|
            group == Renalware.config.ldap_readonly_group
          end
        end

        context "when user currently has clinical role" do
          it "downgrades to read_only role" do
            user = create(:user, role: nil, roles: [clinical_role])

            user.synchronize_ldap_roles

            expect(user.roles.reload).to contain_exactly(readonly_role)
          end

          it "preserves prescriber roles during downgrade" do
            user = create(:user, role: nil,
                                 roles: [clinical_role, prescriber_role, hd_prescriber_role])

            user.synchronize_ldap_roles

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

            user.synchronize_ldap_roles

            expect(user.roles.reload).to contain_exactly(readonly_role, prescriber_role)
            expect(user.reload.updated_at).to eq(initial_updated_at)
          end
        end
      end

      context "when user is not in any valid LDAP group" do
        it "unapproves the user" do
          allow(ldap_adapter).to receive(:user_in_group?) do |username, group|
            username == "renalwareuser-1" &&
              group == Renalware.config.ldap_clinical_group
          end
          user = create(:user, role: nil, roles: [clinical_role], approved: true,
                               username: "renalwareuser-1")

          allow(ldap_adapter).to receive(:user_in_group?).and_return(false)

          user.synchronize_ldap_roles

          expect(user.reload).not_to be_approved
        end

        it "does not modify already unapproved user" do
          allow(ldap_adapter).to receive(:user_in_group?) do |username, group|
            username == "renalwareuser-2" &&
              group == Renalware.config.ldap_clinical_group
          end
          user = create(:user, role: nil, roles: [readonly_role], approved: true,
                               username: "renalwareuser-2", updated_at: 2.minutes.ago)
          user.update_column(:approved, false)
          initial_updated_at = user.reload.updated_at

          allow(ldap_adapter).to receive(:user_in_group?).and_return(false)

          user.synchronize_ldap_roles

          expect(user.reload).not_to be_approved
          expect(user.reload.updated_at).to eq(initial_updated_at)
        end
      end

      context "when user has admin-level roles" do
        it "does not modify super_admin role" do
          allow(ldap_adapter).to receive(:user_in_group?) do |username, group|
            username == "superadmin-1" &&
              group == Renalware.config.ldap_clinical_group
          end
          user = create(:user, role: nil, roles: [super_admin_role], username: "superadmin-1")

          allow(ldap_adapter).to receive(:user_in_group?).and_return(false)

          user.synchronize_ldap_roles

          expect(user.roles.reload).to contain_exactly(super_admin_role)
        end

        it "does not modify admin role" do
          allow(ldap_adapter).to receive(:user_in_group?) do |username, group|
            username == "admin-1" && group == Renalware.config.ldap_clinical_group
          end
          user = create(:user, role: nil, roles: [admin_role], username: "admin-1")

          allow(ldap_adapter).to receive(:user_in_group?).and_return(false)

          user.synchronize_ldap_roles

          expect(user.roles.reload).to contain_exactly(admin_role)
        end

        it "does not modify devops role" do
          allow(ldap_adapter).to receive(:user_in_group?) do |username, group|
            username == "devops-1" && group == Renalware.config.ldap_clinical_group
          end
          user = create(:user, role: nil, roles: [devops_role], username: "devops-1")

          allow(ldap_adapter).to receive(:user_in_group?).and_return(false)

          user.synchronize_ldap_roles

          expect(user.roles.reload).to contain_exactly(devops_role)
        end
      end

      context "when LDAP group check fails" do
        it "raises the LDAP error" do
          # Stub LDAP during user creation to allow the test to proceed
          allow(ldap_adapter).to receive(:user_in_group?).and_return(true)

          user = create(:user, role: nil, roles: [clinical_role], approved: true)

          # Now stub to raise the error when synchronize_ldap_roles is called
          allow(ldap_adapter).to receive(:user_in_group?)
            .and_raise(Renalware::Ldap::Error.new("LDAP error"))

          expect { user.synchronize_ldap_roles }.to raise_error(Renalware::Ldap::Error)
        end
      end
    end
  end
end
