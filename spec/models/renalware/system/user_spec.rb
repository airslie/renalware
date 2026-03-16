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
                 recoverable lockable database_authenticatable)
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
    end

    describe ".from_ldap_omniauth" do
      let!(:clinical_role) { create(:role, :clinical, ad_role_name: "renalware-clinical") }
      let!(:readonly_role) { create(:role, :read_only, ad_role_name: "renalware-readonly") }
      let(:hospital_centre) { create(:hospital_centre, :default) }
      let(:password) { "ldap-password" }
      let(:auth) do
        OmniAuth::AuthHash.new(
          uid: "jbloggs",
          info: {
            email: "JOE.BLOGGS@EXAMPLE.COM",
            first_name: "Joe",
            last_name: "Bloggs"
          },
          extra: {
            raw_info: {
              "memberof" => [
                "CN=Renalware-Clinical,OU=Groups,DC=example,DC=com"
              ]
            }
          }
        )
      end

      before do
        hospital_centre
        allow(Renalware.config).to receive(:ldap_auto_approve_users).and_return(true)
      end

      it "creates a user from the LDAP auth hash and syncs managed roles" do
        user = described_class.from_ldap_omniauth(auth, password)

        expect(user).to be_persisted
        expect(user).to have_attributes(
          username: "jbloggs",
          email: "joe.bloggs@example.com",
          given_name: "Joe",
          family_name: "Bloggs",
          approved: true,
          hospital_centre:
        )
        expect(user.encrypted_password).to be_present
        expect(user.roles.reload).to contain_exactly(clinical_role)
      end

      it "reuses an existing user matched by email and fills in the LDAP username" do
        user = create(
          :user,
          :minimal,
          username: "legacy-username",
          email: "joe.bloggs@example.com",
          given_name: "Legacy",
          family_name: "Existing"
        )

        described_class.from_ldap_omniauth(auth, password)

        expect(user.reload).to have_attributes(
          username: "legacy-username",
          email: "joe.bloggs@example.com",
          given_name: "Legacy",
          family_name: "Existing",
          approved: true,
          hospital_centre:
        )
        expect(user.roles.reload).to contain_exactly(clinical_role)
      end

      it "does not overwrite an existing user matched by username" do
        encrypted_password = ::Devise::Encryptor.digest(described_class, "existing-password")
        user = create(
          :user,
          :minimal,
          username: "jbloggs",
          email: "existing@example.com",
          given_name: "Existing",
          family_name: "Person",
          encrypted_password:,
          roles: [readonly_role]
        )

        described_class.from_ldap_omniauth(auth, password)

        expect(user.reload).to have_attributes(
          email: "existing@example.com",
          given_name: "Existing",
          family_name: "Person"
        )
        expect(user.encrypted_password).to eq(encrypted_password)
        expect(user.roles.reload).to contain_exactly(clinical_role)
      end
    end

    describe ".sync_roles" do
      let!(:clinical_role) { create(:role, :clinical, ad_role_name: "renalware-clinical") }
      let!(:readonly_role) { create(:role, :read_only, ad_role_name: "renalware-readonly") }
      let!(:prescriber_role) { create(:role, :prescriber) }

      it "reconciles managed roles and preserves unmanaged roles" do
        user = create(:user, :minimal, roles: [readonly_role, prescriber_role])

        described_class.sync_roles(
          user,
          [
            "CN=Renalware-Clinical,OU=Groups,DC=example,DC=com"
          ]
        )

        expect(user.roles.reload).to contain_exactly(clinical_role, prescriber_role)
      end

      it "accepts nil or plain role names and removes missing managed roles" do
        user = create(:user, :minimal, roles: [clinical_role, prescriber_role])

        described_class.sync_roles(user, nil)
        expect(user.roles.reload).to contain_exactly(prescriber_role)

        described_class.sync_roles(user, "RENALWARE-READONLY")
        expect(user.roles.reload).to contain_exactly(readonly_role, prescriber_role)
      end

      it "prefers clinical over readonly when both access levels are present" do
        user = create(:user, :minimal, roles: [prescriber_role])

        described_class.sync_roles(
          user,
          [
            "CN=Renalware-Clinical,OU=Groups,DC=example,DC=com",
            "CN=Renalware-Readonly,OU=Groups,DC=example,DC=com"
          ]
        )

        expect(user.roles.reload).to contain_exactly(clinical_role, prescriber_role)
      end
    end

    describe "#valid_password?" do
      let(:ldap_connection) { instance_double(Ldap::Connection) }

      context "when LDAP is disabled" do
        it "uses database authentication" do
          allow(Renalware.config).to receive(:ldap_authentication).and_return(false)
          user = create(:user, password: "password123")

          expect(user.valid_password?("password123")).to be true
          expect(user.valid_password?("wrongpassword")).to be false
        end
      end

      context "when LDAP is enabled" do
        before do
          allow(Renalware.config).to receive(:ldap_authentication).and_return(true)
          allow(Ldap::Connection).to receive(:new).and_return(ldap_connection)
        end

        it "validates the password against LDAP" do
          user = create(:user, username: "testuser", password: "password123")
          allow(ldap_connection).to receive(:valid_credentials?).and_return(true)

          expect(user.valid_password?("correct_password")).to be true
          expect(Ldap::Connection).to have_received(:new)
            .with(username: "testuser", password: "correct_password")
        end

        it "returns false when LDAP rejects the password" do
          user = create(:user, username: "testuser", password: "password123")
          allow(ldap_connection).to receive(:valid_credentials?).and_return(false)

          expect(user.valid_password?("wrongpassword")).to be false
        end
      end
    end
  end
end
