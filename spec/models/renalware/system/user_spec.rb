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
        arr = %i(expirable rememberable registerable validatable trackable timeoutable
                 recoverable lockable database_authenticatable ldap_authenticatable)
        expect(described_class.devise_modules).to include(*arr)
      end
    end

    it "is unapproved by default" do
      expect(build(:user, :minimal, :unapproved)).not_to be_approved
    end

    describe "#active_for_authentication?" do
      it "returns false for unapproved users" do
        user = build(:user, :minimal, approved: false)
        expect(user.active_for_authentication?).to be(false)
      end

      it "returns true for approved users" do
        user = build(:user, :minimal, approved: true)
        expect(user.active_for_authentication?).to be(true)
      end

      it "returns false for banned users" do
        user = build(:user, :minimal, approved: true, banned: true)
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
          user = build(:user, :minimal, role: nil)
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
          user = build(:user, :minimal)
          user.save!

          clinical_role = Role.find_by!(name: :clinical)
          expect(user.roles).to contain_exactly(clinical_role)
        end
      end

      context "when LDAP is enabled" do
        context "when user is not in a valid LDAP group" do
          let(:ldap_connection) { instance_double(Ldap::Connection) }

          before do
            allow(Renalware.config).to receive(:ldap_authentication).and_return(true)
            allow(Ldap::Connection).to receive(:new).and_return(ldap_connection)
          end

          it "prevents user creation with validation error" do
            user = build(:user, :minimal, username: "testuser")
            user.roles = []
            allow(ldap_connection).to receive(:param)
              .with("mail").and_return("test@example.com")
            allow(ldap_connection).to receive(:param)
              .with("givenName").and_return("Test")
            allow(ldap_connection).to receive(:param)
              .with("sn").and_return("User")
            allow(ldap_connection).to receive(:user_in_group?).and_return(false)

            result = user.save

            expect(result).to be false
            expect(user.persisted?).to be(false)
            expect(user.errors[:base])
              .to include("You are not authorised to access this system")
          end
        end
      end
    end

    describe "#ldap_before_save" do
      let(:user) { build(:user, :minimal, username: "testuser") }
      let(:ldap_connection) { instance_double(Ldap::Connection) }

      before do
        allow(Renalware.config).to receive(:ldap_authentication).and_return(true)
        allow(Ldap::Connection).to receive(:new).and_return(ldap_connection)
        allow(ldap_connection).to receive(:param)
          .with("sn")
          .and_return("Doe")
        allow(ldap_connection).to receive(:param)
          .with("mail")
          .and_return("john.doe@example.com")
        allow(user).to receive(:in_valid_ldap_group?).and_return(true)
      end

      context "when givenName is present" do
        it "sets given_name from givenName attribute" do
          allow(ldap_connection).to receive(:param)
            .with("givenName")
            .and_return("John")
          allow(user).to receive(:in_valid_ldap_group?).and_return(true)

          user.ldap_before_save

          expect(user.given_name).to eq("John")
        end
      end

      context "when ldap_auto_approve_users is enabled" do
        it "sets approved to true" do
          allow(Renalware.config).to receive(:ldap_auto_approve_users).and_return(true)
          allow(ldap_connection).to receive(:param)
            .with("givenName")
            .and_return("John")
          allow(user).to receive(:in_valid_ldap_group?).and_return(true)

          user.ldap_before_save

          expect(user.approved).to be(true)
        end
      end

      context "when ldap_auto_approve_users is disabled" do
        it "sets approved to false" do
          allow(Renalware.config).to receive(:ldap_auto_approve_users).and_return(false)
          allow(ldap_connection).to receive(:param)
            .with("givenName")
            .and_return("John")
          allow(user).to receive(:in_valid_ldap_group?).and_return(true)

          user.ldap_before_save

          expect(user.approved).to be(false)
        end
      end

      context "when user is not in a valid LDAP group" do
        it "does not set approved status" do
          allow(ldap_connection).to receive(:param)
            .with("givenName")
            .and_return("John")
          allow(user).to receive(:in_valid_ldap_group?).and_return(false)

          approved_before = user.approved
          user.ldap_before_save

          expect(user.approved).to eq(approved_before)
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
      let(:ldap_connection) { instance_double(Ldap::Connection) }

      before do
        allow(Renalware.config).to receive(:ldap_authentication).and_return(true)
        allow(Ldap::Connection).to receive(:new).and_return(ldap_connection)
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
          allow(ldap_connection).to receive(:user_in_group?) do |group|
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
          allow(ldap_connection).to receive(:user_in_group?) do |group|
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

      context "when user is not in a valid LDAP group" do
        let(:username) { "renalwareuser-1" }
        let(:roles) { [clinical_role] }
        let(:user) do
          create(:user, role: nil, roles:, approved: true, username:, updated_at: 2.minutes.ago)
        end

        before do
          allow(ldap_connection).to receive(:user_in_group?).and_return(true, false)
        end

        it "removes LDAP roles but keeps user approved" do
          pending "need to think about logic here as validation says approved user must have a role"
          user.roles = []
          user.save!

          user.synchronize_ldap_roles

          expect(user.reload).to be_approved
          expect(user.roles).to be_empty
        end
      end

      context "when user has admin-level roles" do
        it "does not modify super_admin role" do
          allow(ldap_connection).to receive(:user_in_group?) do |group|
            group == Renalware.config.ldap_clinical_group
          end
          user = create(:user, role: nil, roles: [super_admin_role], username: "superadmin-1")

          user.synchronize_ldap_roles

          expect(user.roles.reload).to contain_exactly(super_admin_role)
        end

        it "does not modify admin role" do
          allow(ldap_connection).to receive(:user_in_group?) do |group|
            group == Renalware.config.ldap_clinical_group
          end
          user = create(:user, role: nil, roles: [admin_role], username: "admin-1")

          user.synchronize_ldap_roles

          expect(user.roles.reload).to contain_exactly(admin_role)
        end

        it "does not modify devops role" do
          allow(ldap_connection).to receive(:user_in_group?) do |group|
            group == Renalware.config.ldap_clinical_group
          end
          user = create(:user, role: nil, roles: [devops_role], username: "devops-1")

          user.synchronize_ldap_roles

          expect(user.roles.reload).to contain_exactly(devops_role)
        end
      end

      context "when LDAP group check fails" do
        it "raises the LDAP error" do
          allow(ldap_connection).to receive(:user_in_group?).and_return(true)

          user = create(:user, role: nil, roles: [clinical_role], approved: true)

          allow(ldap_connection).to receive(:user_in_group?)
            .and_raise(Renalware::Ldap::Error.new("LDAP error"))

          expect { user.synchronize_ldap_roles }.to raise_error(Renalware::Ldap::Error)
        end
      end
    end

    describe "#valid_password?" do
      let(:ldap_connection) { instance_double(Ldap::Connection) }
      let(:user) { create(:user, username: "testuser", approved: true) }

      before do
        create(:role, :clinical)
        allow(Renalware.config).to receive(:ldap_authentication).and_return(true)
        allow(Ldap::Connection).to receive(:new).and_return(ldap_connection)
        # Stub group membership for user creation - we need the user to be in a group initially
        allow(ldap_connection).to receive(:user_in_group?).and_return(true)
      end

      context "when LDAP is disabled" do
        it "uses database authentication" do
          allow(Renalware.config).to receive(:ldap_authentication).and_return(false)
          user = create(:user, password: "password123")

          expect(user.valid_password?("password123")).to be true
          expect(user.valid_password?("wrongpassword")).to be false
        end
      end

      context "when LDAP is enabled" do
        context "when user has valid LDAP credentials" do
          it "returns true regardless of group membership" do
            allow(ldap_connection).to receive(:valid_credentials?)
              .and_return(true)

            expect(user.valid_password?("correct_password")).to be true
          end
        end

        context "when user has invalid LDAP credentials" do
          it "returns false" do
            allow(ldap_connection).to receive(:valid_credentials?)
              .and_return(false)

            expect(user.valid_password?("wrong_password")).to be false
          end
        end
      end
    end
  end
end
