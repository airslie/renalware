module Renalware
  describe "LDAP Authentication", :js do
    let(:hospital_centre) { create(:hospital_centre, :default) }

    before do
      allow(Renalware.config).to receive_messages(
        database_authentication_enabled?: false,
        ldap_authentication_enabled?: true,
        ldap_auto_approve_users: true
      )
    end

    it "renders the LDAP sign-in form posting to the omniauth callback" do
      hospital_centre
      visit new_user_session_path

      expect(page).to have_content("Sign in")
      expect(page).to have_css("form[action='#{user_ldap_omniauth_callback_path}']")
      expect(page).to have_field("Username")
      expect(page).to have_field("Password")
      expect(page).to have_button("Sign in")
    end

    it "hides signup and forgot password links" do
      visit new_user_session_path

      expect(page).to have_content("Sign in")
      expect(page).to have_no_link("Sign up")
      expect(page).to have_no_link("Forgotten your password?")
    end

    context "when entra sign-in is enabled as well" do
      before do
        allow(Renalware.config).to receive(:entra_authentication_enabled?).and_return(true)
      end

      it "shows the Microsoft sign-in option" do
        visit new_user_session_path

        expect(page).to have_link("Sign in with Microsoft")
      end
    end

    context "when database authentication is enabled alongside LDAP" do
      before do
        allow(Renalware.config).to receive(:database_authentication_enabled?).and_return(true)
      end

      it "shows both password-based sign-in forms" do
        visit new_user_session_path

        expect(page).to have_content("Sign in with a local account")
        expect(page).to have_content("Sign in with LDAP")
        expect(page).to have_css("form[action='#{new_user_session_path}']")
        expect(page).to have_css("form[action='#{user_ldap_omniauth_callback_path}']")
      end
    end
  end
end
