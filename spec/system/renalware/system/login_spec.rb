module Renalware
  describe "Authentication", :js do
    let(:last_sign_in_at) { nil }
    let(:user) { create(:user, :clinical) }
    let(:unapproved_user) { create(:user, :unapproved) }

    before { create(:role, :clinical) }

    context "when previously signed in" do
      let(:user) { create(:user, :clinical, :previously_signed_in) }

      it "successfully signs in a user" do
        visit root_path

        fill_in "Username", with: user.username
        fill_in "Password", with: user.password
        click_on "Log in"

        expect(page).to have_content "You last signed in 1 day ago."
      end
    end

    it "attempts to sign in with no credentials" do
      visit root_path

      click_on "Log in"

      expect(page).to have_current_path new_user_session_path
      expect(page).to have_text "Invalid Username or password"
    end

    context "when attempting to sign in with invalid credentials" do
      it "shows the failed attempt on a subsequent login" do
        visit root_path

        fill_in "Username", with: user.username
        fill_in "Password", with: "wuhfweilubfwlf"
        click_on "Log in"

        expect(page).to have_current_path new_user_session_path
        expect(page).to have_text "Invalid Username or password"

        visit root_path

        fill_in "Username", with: user.username
        fill_in "Password", with: user.password
        click_on "Log in"

        expect(page).to have_current_path root_path
        expect(page).to have_content(
          "Your account had a failed sign-in attempt less than a minute ago"
        )
      end
    end

    it "An unapproved user signs in with valid credentials" do
      visit root_path

      fill_in "Username", with: unapproved_user.username
      fill_in "Password", with: unapproved_user.password
      click_on "Log in"

      expect(page).to have_current_path new_user_session_path
      expect(page).to have_text "Your account needs approval"
    end

    context "when an approved user is valid" do
      let(:user) { create(:user, :clinical) }

      it "signs in with valid credentials" do
        visit root_path

        fill_in "Username", with: user.username
        fill_in "Password", with: user.password
        click_on "Log in"

        expect(page).to have_current_path root_path

        # It creates a signin event
        # NOTE: AhoyMatey no longer creates events in test mode
        # TODO: work out how to set up tracking in just this test
        # system_event = Renalware::System::Event.order(time: :desc).last
        # expect(system_event).to have_attributes(
        #   user_id: user.id,
        #   name: "signin"
        # )
      end
    end

    context "when an approved user is invalid" do
      let(:user) { create(:user, :clinical, signature: nil) }

      it "still logs them in" do
        visit root_path

        fill_in "Username", with: user.username
        fill_in "Password", with: user.password
        click_on "Log in"

        # Note since Devise 4.4.o a redirect to dashboard will only occur if user.valid?
        # Our conditional update validation in User means by default many users are not valid
        # after creation as they might not have a signature etc (ideally signature etc should be
        # moved to a Profile model)
        # So here we check that whatever 'hack' we have introduced to get around Devise trying to
        # validate the model before redirect, works.
        expect(page).to have_current_path(root_path)
      end
    end

    context "when user is signed in" do
      it "signs them out" do
        login_as_clinical
        visit root_path

        click_on "Log out"

        expect(page).to have_current_path new_user_session_path
      end
    end

    context "when an inactive user attempts to sign in" do
      it "does not sign them in" do
        inactive = create(:user, last_activity_at: 90.days.ago)

        visit new_user_session_path

        fill_in "Username", with: inactive.username
        fill_in "Password", with: inactive.password
        click_on "Log in"

        expect(page).to have_current_path new_user_session_path
        expect(page).to have_text "Your account has expired due to inactivity"
      end
    end

    context "when an almost inactive user attempts to sign in" do
      it "signs them in" do
        inactive = create(:user, :clinical, last_activity_at: 89.days.ago)

        visit new_user_session_path

        fill_in "Username", with: inactive.username
        fill_in "Password", with: inactive.password
        click_on "Log in"

        expect(page).to have_current_path root_path
      end
    end

    context "when LDAP authentication is enabled" do
      before do
        allow(Renalware.config).to receive(:ldap_authentication).and_return(true)
        allow(::Devise::LDAP::Adapter).to receive(:in_ldap_group?) do |_username, group|
          group == Renalware::LdapAuthenticatable::RENALWARE_GROUP
        end
      end

      it "hides signup and forgot password links" do
        visit new_user_session_path

        expect(page).to have_content("Sign in") # Wait for page to load
        expect(page).to have_no_link("Sign up")
        expect(page).to have_no_link("Forgotten your password?")
      end

      it "authenticates user with valid LDAP credentials" do
        allow(::Devise::LDAP::Adapter).to receive(:valid_credentials?)
          .with(user.username, "ldap_password")
          .and_return(true)
        allow(::Devise::LDAP::Adapter).to receive(:in_ldap_group?)
          .with(user.username, Renalware::LdapAuthenticatable::RENALWARE_GROUP)
          .and_return(true)

        visit new_user_session_path

        fill_in "Username", with: user.username
        fill_in "Password", with: "ldap_password"
        click_on "Log in"

        expect(page).to have_current_path(root_path)
        expect(page).to have_content("Signed in successfully")
      end

      it "rejects user with invalid LDAP credentials" do
        allow(::Devise::LDAP::Adapter).to receive(:valid_credentials?)
          .with(user.username, "wrong_password")
          .and_return(false)

        visit new_user_session_path

        fill_in "Username", with: user.username
        fill_in "Password", with: "wrong_password"
        click_on "Log in"

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_text("Invalid Username or password")
      end

      it "handles LDAP server connection errors gracefully" do
        allow(::Devise::LDAP::Adapter).to receive(:valid_credentials?)
          .with(user.username, "any_password")
          .and_raise(StandardError.new("LDAP server unreachable"))

        visit new_user_session_path

        fill_in "Username", with: user.username
        fill_in "Password", with: "any_password"
        click_on "Log in"

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_text("Invalid Username or password")
      end
    end

    context "when LDAP authentication is disabled" do
      before do
        allow(Renalware.config).to receive(:ldap_authentication).and_return(false)
      end

      it "shows signup link" do
        visit new_user_session_path

        expect(page).to have_link("Sign up")
        # Note: forgot password link may not appear if recoverable module isn't loaded
        # This depends on how devise modules are configured at boot time
      end

      it "authenticates user with valid local credentials" do
        visit new_user_session_path

        fill_in "Username", with: user.username
        fill_in "Password", with: user.password
        click_on "Log in"

        expect(page).to have_current_path(root_path)
        expect(page).to have_content("Signed in successfully")
      end

      it "rejects user with invalid local credentials" do
        visit new_user_session_path

        fill_in "Username", with: user.username
        fill_in "Password", with: "wrong_password"
        click_on "Log in"

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_text("Invalid Username or password")
      end
    end
  end
end
