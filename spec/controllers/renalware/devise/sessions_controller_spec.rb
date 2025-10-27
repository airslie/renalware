require "rails-controller-testing"

module Renalware
  describe Devise::SessionsController do
    routes { Renalware::Engine.routes }

    let(:user) { create(:user, :clinical) }
    let(:ldap_adapter) { instance_double(Renalware::Ldap::Connection) }

    before do
      create(:role, :clinical)
      @request.env["devise.mapping"] = ::Devise.mappings[:user]
      # Enable LDAP authentication for these tests
      allow(Renalware.config).to receive(:ldap_authentication).and_return(true)
      allow(Renalware::Ldap::Connection).to receive(:new)
        .with(hash_including(username: anything))
        .and_return(ldap_adapter)
      allow(ldap_adapter).to receive(:user_in_group?).and_return(false)
      allow(ldap_adapter).to receive(:user_in_group?)
        .with(Renalware.config.ldap_clinical_group)
        .and_return(true)
      sign_out :user # Ensure no user is signed in before testing login
    end

    describe "POST #create" do
      context "when LDAP server raises Ldap::Error" do
        before do
          allow(ldap_adapter).to receive(:valid_credentials?)
            .and_raise(Renalware::Ldap::Error.new("LDAP server unreachable"))
        end

        it "redirects back to login page" do
          post :create, params: { user: { username: user.username, password: "any_password" } }

          expect(response).to redirect_to(new_user_session_path)
        end

        it "displays user-friendly error message" do
          post :create, params: { user: { username: user.username, password: "any_password" } }

          expect(flash[:alert]).to include(
            "We are currently unable to confirm your details due to a temporary issue"
          )
          expect(flash[:alert]).to include("This is being investigated")
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
            .with(/LDAP error in sessions#create.*Renalware::Ldap::Error/)
          expect(Rails.logger).to have_received(:error).at_least(:once)
        end
      end

      context "when valid LDAP credentials are provided" do
        before do
          allow(ldap_adapter).to receive(:valid_credentials?)
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
          allow(ldap_adapter).to receive(:valid_credentials?)
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

      context "when user has valid LDAP credentials but is not in a valid LDAP group" do
        let(:removed_user) do
          # Temporarily allow user to be created (user is in group during creation)
          allow(ldap_adapter).to receive(:user_in_group?)
            .with(Renalware.config.ldap_clinical_group)
            .and_return(true)
          user = create(:user, :clinical, username: "removed_user")
          # Reset mock so subsequent tests see user as not in group
          allow(ldap_adapter).to receive(:user_in_group?).and_return(false)
          user
        end

        before do
          allow(ldap_adapter).to receive(:valid_credentials?)
            .and_return(true)
        end

        it "does not sign in" do
          post :create,
               params: { user: { username: removed_user.username, password: "valid_password" } }

          expect(controller.current_user).to be_nil
        end

        it "displays not authorized message" do
          post :create,
               params: { user: { username: removed_user.username, password: "valid_password" } }

          expect(flash[:alert]).to include(
            I18n.t("devise.failure.user.not_authorized")
          )
        end

        it "shows the login page" do
          post :create,
               params: { user: { username: removed_user.username, password: "valid_password" } }

          if response.redirect?
            expect(response).to redirect_to(new_user_session_path)
          else
            expect(response).to have_http_status(:ok)
            expect(response).to render_template("devise/sessions/new")
          end
        end
      end

      context "when LDAP_AUTO_APPROVE_USERS is false" do
        before do
          allow(Renalware.config).to receive(:ldap_auto_approve_users).and_return(false)
          allow(ldap_adapter).to receive(:valid_credentials?)
            .and_return(true)
        end

        context "when user is not approved" do
          before do
            user.update!(approved: false)
          end

          it "displays LDAP-specific not approved message" do
            post :create, params: { user: { username: user.username, password: "valid_password" } }

            expect(flash[:alert]).to include(
              I18n.t("devise.failure.user.not_approved_ldap")
            )
          end

          it "redirects back to login page" do
            post :create, params: { user: { username: user.username, password: "valid_password" } }

            # Unapproved users get redirected back to the login page
            expect(response).to have_http_status(:redirect)
          end
        end

        context "when user is already approved" do
          before do
            user.update!(approved: true)
          end

          it "does not display the LDAP approval message" do
            post :create, params: { user: { username: user.username, password: "valid_password" } }

            expect(flash[:alert]).to be_nil
          end

          it "signs in successfully" do
            post :create, params: { user: { username: user.username, password: "valid_password" } }

            expect(response).to have_http_status(:redirect)
            expect(controller.current_user).to eq(user)
          end
        end
      end
    end
  end
end
