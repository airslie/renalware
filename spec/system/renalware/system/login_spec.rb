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

    it "attempts to sign in with a non-existent username" do
      visit root_path

      fill_in "Username", with: "nonexistentuser123"
      fill_in "Password", with: "anypassword"
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

    context "when a banned user attempts to sign in" do
      it "does not sign them in" do
        banned_user = create(:user, :clinical, banned: true)

        visit new_user_session_path

        fill_in "Username", with: banned_user.username
        fill_in "Password", with: banned_user.password
        click_on "Log in"

        expect(page).to have_current_path new_user_session_path
        expect(page).to have_text "You have been actively blocked from logging in"
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
  end
end
