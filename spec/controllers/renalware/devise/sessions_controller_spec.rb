require "rails-controller-testing"

module Renalware
  describe Devise::SessionsController do
    let(:user) { create(:user, :clinical) }
    let(:ldap_adapter) { instance_double(Renalware::Ldap::Connection) }

    before do
      @request.env["devise.mapping"] = ::Devise.mappings[:user]
      sign_out :user
    end

    describe "POST #create" do
      let!(:user) { create(:user, password: "password123") }

      before do
        allow(Renalware.config).to receive_messages(
          ldap_authentication_enabled?: false,
          database_authentication_enabled?: true
        )
      end

      it "updates last_failed_sign_in_at on invalid credentials" do
        freeze_time do
          expect {
            post :create, params: { user: { username: user.username, password: "wrong_password" } }
          }.to change {
                 user.reload.last_failed_sign_in_at
               }.to(be_within(1.second).of(Time.current))
        end
      end

      it "signs in successfully with valid credentials" do
        post :create, params: { user: { username: user.username, password: "password123" } }

        expect(response).to have_http_status(:redirect)
        expect(controller.current_user).to eq(user)
      end

      it "redirects back to sign in when the login form authenticity check fails" do
        allow(controller).to receive(:verified_request?).and_return(false)

        post :create, params: { user: { username: user.username, password: "password123" } }

        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq("The sign-in page expired. Please try again.")
      end
    end
  end
end
