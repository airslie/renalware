module Renalware
  RSpec.describe "LDAP error handling" do
    let(:test_controller_class) do
      Class.new(Renalware::ApplicationController) do
        def trigger_ldap_error
          raise Ldap::Error, "LDAP connection failed"
        end
      end
    end

    before do
      stub_const("TestLdapErrorsController", test_controller_class)

      Rails.application.routes.draw do
        get "/test_ldap_errors/trigger_ldap_error",
            to: "test_ldap_errors#trigger_ldap_error"
      end
    end

    after do
      Rails.application.reload_routes!
    end

    describe "when Ldap::Error is raised" do
      it "redirects back with error message" do
        get "/test_ldap_errors/trigger_ldap_error",
            headers: { "HTTP_REFERER" => "/renalware" }

        expect(response).to redirect_to("/renalware")
        expect(flash[:alert]).to eq(
          I18n.t("renalware.system.errors.ldap.service_unavailable")
        )
      end

      it "logs the error" do
        allow(Rails.logger).to receive(:error)

        get "/test_ldap_errors/trigger_ldap_error",
            headers: { "HTTP_REFERER" => "/renalware" }

        expect(Rails.logger).to have_received(:error)
          .with(/LDAP error in test_ldap_errors#trigger_ldap_error.*Renalware::Ldap::Error/)
        expect(Rails.logger).to have_received(:error).at_least(:once)
      end

      it "redirects to fallback location when no referer present" do
        get "/test_ldap_errors/trigger_ldap_error"

        expect(response).to be_redirect
        expect(flash[:alert]).to eq(
          I18n.t("renalware.system.errors.ldap.service_unavailable")
        )
      end
    end
  end
end
