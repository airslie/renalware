module Renalware
  describe "LDAP Authentication", :js do
    let(:ldap_user) { build(:user, :clinical, :with_ldap_enabled) }
    let(:ldap_adapter) { instance_double(Renalware::Ldap::Adapter) }

    before do
      allow(Renalware.config).to receive_messages(
        ldap_authentication: true,
        ldap_auto_approve_users: true
      )
      allow(Renalware::Ldap::Adapter).to receive(:new).and_return(ldap_adapter)
    end

    context "when user enters valid credentials" do
      before do
        allow(ldap_adapter).to receive(:valid_credentials?)
          .with(ldap_user.username, "ldap_password")
          .and_return(true)

        allow(ldap_adapter).to receive(:user_in_group?)
          .with(ldap_user.username, Renalware.config.ldap_clinical_group)
          .and_return(true)

        allow(ldap_adapter).to receive(:param).with(ldap_user.username, "mail")
          .and_return(ldap_user.email)
        allow(ldap_adapter).to receive(:param).with(ldap_user.username, "givenName")
          .and_return(ldap_user.given_name)
        allow(ldap_adapter).to receive(:param).with(ldap_user.username, "sn")
          .and_return(ldap_user.family_name)
      end

      it "successfully logins in a new user" do
        visit new_user_session_path
        fill_in "Username", with: ldap_user.username
        fill_in "Password", with: "ldap_password"
        click_on "Log in"

        fullname = "#{ldap_user.given_name} #{ldap_user.family_name}"
        expect(page).to have_content("#{fullname}\nClinical")
        expect(page).to have_current_path(root_path)
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
        allow(ldap_adapter).to receive(:valid_credentials?)
          .with(ldap_user.username, "ldap_password")
          .and_return(false)
      end

      it "shows an error" do
        visit new_user_session_path
        fill_in "Username", with: ldap_user.username
        fill_in "Password", with: "ldap_password"
        click_on "Log in"

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_text("Invalid Username or password")
      end
    end

    context "when user is not in a valid LDAP group" do
      before do
        allow(ldap_adapter).to receive(:valid_credentials?)
          .with(ldap_user.username, "ldap_password")
          .and_return(true)

        allow(ldap_adapter).to receive(:user_in_group?).and_return(false)
        allow(ldap_adapter).to receive(:param)
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
