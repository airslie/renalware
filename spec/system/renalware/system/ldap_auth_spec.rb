module Renalware
  describe "LDAP Authentication", :js do
    let(:ldap_user) { build(:user, :clinical, :with_ldap_enabled) }
    let(:ldap_connection) { instance_double(Renalware::Ldap::Connection) }
    let(:hospital_centre) { create(:hospital_centre, :default) }

    before do
      allow(Renalware.config).to receive_messages(
        ldap_authentication: true,
        ldap_auto_approve_users: true
      )
      allow(Renalware::Ldap::Connection).to receive(:new).and_return(ldap_connection)
    end

    context "when user enters valid credentials" do
      before do
        allow(ldap_connection).to receive(:valid_credentials?)
          .and_return(true)

        allow(ldap_connection).to receive(:user_in_group?)
          .with(Renalware.config.ldap_clinical_group)
          .and_return(true)

        allow(ldap_connection).to receive(:param).with("mail")
          .and_return(ldap_user.email)
        allow(ldap_connection).to receive(:param).with("givenName")
          .and_return(ldap_user.given_name)
        allow(ldap_connection).to receive(:param).with("sn")
          .and_return(ldap_user.family_name)
      end

      it "successfully logins in a new user" do
        hospital_centre
        expect(Renalware::Hospitals::Centre.site_default).to eq(hospital_centre)

        visit new_user_session_path
        fill_in "Username", with: ldap_user.username
        fill_in "Password", with: "ldap_password"
        click_on "Log in"

        fullname = "#{ldap_user.given_name} #{ldap_user.family_name}"
        expect(page).to have_content("#{fullname}\nClinical")
        expect(page).to have_current_path(root_path)

        user = User.find_by(username: ldap_user.username)
        expect(user).to have_attributes(
          email: ldap_user.email,
          given_name: ldap_user.given_name,
          family_name: ldap_user.family_name,
          hospital_centre: hospital_centre,
          approved: true
        )
      end

      it "successfully logs in an existing user" do
        ldap_user.save!

        visit new_user_session_path
        fill_in "Username", with: ldap_user.username
        fill_in "Password", with: "ldap_password"
        click_on "Log in"

        fullname = "#{ldap_user.given_name} #{ldap_user.family_name}"
        expect(page).to have_content("#{fullname}\nClinical")
        expect(page).to have_current_path(root_path)
      end

      it "hides signup and forgot password links" do
        visit new_user_session_path

        expect(page).to have_content("Sign in") # Wait for page to load
        expect(page).to have_no_link("Sign up")
        expect(page).to have_no_link("Forgotten your password?")
      end

      context "when the user is not approved" do
        before do
          allow(Renalware.config).to receive(:ldap_auto_approve_users).and_return(false)
        end

        it "shows the approval message" do
          visit new_user_session_path
          fill_in "Username", with: ldap_user.username
          fill_in "Password", with: "ldap_password"
          click_on "Log in"

          expect(page).to have_content(
            "Your credentials have been verified. Please contact your administrator " \
            "to approve your access to this system."
          )
        end
      end
    end

    context "when user enters invalid credentials" do
      before do
        allow(ldap_connection).to receive(:valid_credentials?)
          .and_return(false)
      end

      it "shows an error" do
        visit new_user_session_path
        fill_in "Username", with: ldap_user.username
        fill_in "Password", with: "ldap_password"
        click_on "Log in"

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_text("Invalid username or password")
      end
    end

    context "when user is not in a valid LDAP group" do
      before do
        allow(ldap_connection).to receive_messages(valid_credentials?: true, user_in_group?: false)
        allow(ldap_connection).to receive(:param)
      end

      it "shows an error" do
        visit new_user_session_path
        fill_in "Username", with: ldap_user.username
        fill_in "Password", with: "ldap_password"
        click_on "Log in"

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_text("You are not authorised to access this system")
      end
    end
  end
end
