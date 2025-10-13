require "rails-controller-testing"

module Renalware
  describe Devise::SessionsController do
    routes { Renalware::Engine.routes }

    let(:user) { create(:user, :clinical) }

    before do
      create(:role, :clinical)
      @request.env["devise.mapping"] = ::Devise.mappings[:user]
      allow(Renalware.config).to receive(:ldap_authentication).and_return(true)
      allow(::Devise::LDAP::Adapter).to receive(:in_ldap_group?) do |_username, group, _attr|
        group == Renalware::LdapAuthenticatable::RENALWARE_GROUP
      end
      sign_out :user # Ensure no user is signed in before testing login
    end

    describe "POST #create" do
      context "when LDAP server raises Net::LDAP::Error" do
        before do
          allow(::Devise::LDAP::Adapter).to receive(:valid_credentials?)
            .with(user.username, "any_password")
            .and_raise(Net::LDAP::Error.new("LDAP server unreachable"))
        end

        it "returns 503 status" do
          post :create, params: { user: { username: user.username, password: "any_password" } }

          expect(response).to have_http_status(:service_unavailable)
        end

        it "displays user-friendly error message" do
          post :create, params: { user: { username: user.username, password: "any_password" } }

          expect(flash.now[:alert]).to include(
            "We are currently unable to confirm your details due to a temporary issue"
          )
          expect(flash.now[:alert]).to include("This is being investigated")
        end

        it "renders the new template" do
          post :create, params: { user: { username: user.username, password: "any_password" } }

          expect(response).to render_template(:new)
        end

        it "does not update last_failed_sign_in_at" do
          original_timestamp = user.last_failed_sign_in_at

          post :create, params: { user: { username: user.username, password: "any_password" } }

          expect(user.reload.last_failed_sign_in_at).to eq(original_timestamp)
        end

        it "logs the LDAP error" do
          allow(Rails.logger).to receive(:error)

          post :create, params: { user: { username: user.username, password: "any_password" } }

          expect(Rails.logger).to have_received(:error)
            .with(/LDAP error in sessions#create.*Net::LDAP::Error/)
          expect(Rails.logger).to have_received(:error).at_least(:once)
        end
      end

      context "when LDAP raises DeviseLdapAuthenticatable::LdapException" do
        before do
          allow(::Devise::LDAP::Adapter).to receive(:valid_credentials?)
            .with(user.username, "any_password")
            .and_raise(DeviseLdapAuthenticatable::LdapException.new("Connection timeout"))
        end

        it "returns 503 status" do
          post :create, params: { user: { username: user.username, password: "any_password" } }

          expect(response).to have_http_status(:service_unavailable)
        end

        it "displays user-friendly error message" do
          post :create, params: { user: { username: user.username, password: "any_password" } }

          expect(flash.now[:alert]).to include(
            "We are currently unable to confirm your details due to a temporary issue"
          )
        end

        it "renders the new template" do
          post :create, params: { user: { username: user.username, password: "any_password" } }

          expect(response).to render_template(:new)
        end

        it "does not update last_failed_sign_in_at" do
          original_timestamp = user.last_failed_sign_in_at

          post :create, params: { user: { username: user.username, password: "any_password" } }

          expect(user.reload.last_failed_sign_in_at).to eq(original_timestamp)
        end
      end

      context "when valid LDAP credentials are provided" do
        before do
          allow(::Devise::LDAP::Adapter).to receive(:valid_credentials?)
            .with(user.username, "valid_password")
            .and_return(true)
          allow(::Devise::LDAP::Adapter).to receive(:in_ldap_group?)
            .with(user.username, Renalware::LdapAuthenticatable::RENALWARE_GROUP, "member")
            .and_return(true)
        end

        it "signs in successfully" do
          post :create, params: { user: { username: user.username, password: "valid_password" } }

          expect(response).to have_http_status(:redirect)
          expect(controller.current_user).to eq(user)
        end
      end

      context "when invalid LDAP credentials are provided" do
        before do
          allow(::Devise::LDAP::Adapter).to receive(:valid_credentials?)
            .with(user.username, "wrong_password")
            .and_return(false)
        end

        it "does not sign in" do
          post :create, params: { user: { username: user.username, password: "wrong_password" } }

          expect(controller.current_user).to be_nil
        end

        it "updates last_failed_sign_in_at" do
          freeze_time do
            expect {
              post :create,
                   params: { user: { username: user.username, password: "wrong_password" } }
            }.to change {
                   user.reload.last_failed_sign_in_at
                 }.to(be_within(1.second).of(Time.current))
          end
        end
      end
    end
  end
end
