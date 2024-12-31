module Renalware
  describe "Authentication" do
    let(:user) { create(:user, :clinical) }
    let(:unapproved_user) { create(:user, :unapproved) }

    it "A user attempts to authenticate with invalid credentials" do
      visit root_path

      expect(page).to have_current_path(new_user_session_path)

      fill_in "Username", with: user.username
      fill_in "Password", with: "wuhfweilubfwlf"
      click_on "Log in"

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_text(/Invalid username or password/i)
    end

    it "An unapproved user authenticates with valid credentials" do
      visit root_path

      expect(page).to have_current_path(new_user_session_path)

      fill_in "Username", with: unapproved_user.username
      fill_in "Password", with: unapproved_user.password
      click_on "Log in"

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_text(/Your account needs approval before you can access the system/)
    end

    context "when the user has a complete 'profile' eg signature, professional_position etc " \
            "meaning user.valid? is true" do
      let(:user) { create(:user, :clinical) } # will be valid? once created

      it "An approved user authenticates with valid credentials" do
        visit root_path

        expect(page).to have_current_path(new_user_session_path)

        fill_in "Username", with: user.username
        fill_in "Password", with: user.password
        click_on "Log in"

        expect(page).to have_current_path(root_path)

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

    context "when the user has an incomplete 'profile' eg signature, professional_position etc " \
            "meaning user.valid? is false" do
      let(:user) { create(:user, :clinical, signature: nil) } # will not be valid? once created

      it "An approved user should still be able to login" do
        visit root_path

        expect(page).to have_current_path(new_user_session_path)

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

    it "An authenticated user signs out" do
      login_as_clinical
      visit root_path

      click_on "Log out"

      expect(page).to have_current_path(new_user_session_path)
    end

    it "An inactive user attempts to authenticate" do
      inactive = create(:user, last_activity_at: 90.days.ago)

      visit new_user_session_path

      fill_in "Username", with: inactive.username
      fill_in "Password", with: inactive.password
      click_on "Log in"

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_text(
        /Your account has expired due to inactivity\. Please contact the site administrator/
      )
    end

    it "A fairly inactive user attempts to authenticate" do
      inactive = create(:user, :clinical, last_activity_at: 89.days.ago)

      visit new_user_session_path

      fill_in "Username", with: inactive.username
      fill_in "Password", with: inactive.password
      click_on "Log in"

      expect(page).to have_current_path(root_path)
    end
  end
end
