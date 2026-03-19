require "rails-controller-testing"

module Renalware
  describe Devise::OmniauthCallbacksController do
    routes { Rails.application.routes }

    let(:auth) do
      OmniAuth::AuthHash.new(
        uid: "jbloggs",
        info: {
          email: "joe.bloggs@example.com",
          first_name: "Joe",
          last_name: "Bloggs"
        },
        extra: { raw_info: { "memberof" => ["CN=Renalware-Clinical,OU=Groups,DC=example,DC=com"] } }
      )
    end

    before do
      @request.env["devise.mapping"] = ::Devise.mappings[:user]
      request.env["omniauth.auth"] = auth
    end

    describe "POST #ldap" do
      it "signs in and redirects when the LDAP callback provisions a user" do
        user = create(:user)
        allow(User).to receive(:from_ldap_omniauth).with(auth, "ldap-password").and_return(user)

        post :ldap, params: { password: "ldap-password" }

        expect(response).to have_http_status(:redirect)
        expect(controller.current_user).to eq(user)
      end

      it "redirects back to sign in when the callback user is not persisted" do
        user = build_stubbed(:user)
        allow(user).to receive(:persisted?).and_return(false)
        allow(User).to receive(:from_ldap_omniauth).and_return(user)

        post :ldap, params: { password: "ldap-password" }

        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq("Could not sign in with LDAP.")
      end

      it "logs and redirects when the callback raises" do
        allow(User).to receive(:from_ldap_omniauth).and_raise(Renalware::Ldap::Error, "LDAP down")
        allow(Rails.logger).to receive(:warn)

        post :ldap, params: { password: "ldap-password" }

        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq("LDAP sign-in failed.")
        expect(Rails.logger).to have_received(:warn).with(/LDAP login failed: Renalware::Ldap::Error/)
      end
    end
  end
end
