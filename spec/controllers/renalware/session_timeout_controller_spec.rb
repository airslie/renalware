require "rails-controller-testing"

module Renalware
  describe SessionTimeoutController do
    routes { Renalware::Engine.routes }

    describe "GET #keep_session_alive" do
      it "returns a server-calculated expires_at_epoch_ms JSON value" do
        freeze_time do
          get :keep_session_alive, format: :json, xhr: true

          expect(response).to have_http_status(:ok)

          payload = JSON.parse(response.body)
          expect(payload).to include("expires_at_epoch_ms")
          expect(payload["expires_at_epoch_ms"]).to be_a(Integer)
          expect(payload["expires_at_epoch_ms"]).to be > Time.zone.now.to_i * 1000
        end
      end

      it "returns unauthorized for unauthenticated requests" do
        sign_out :user

        get :keep_session_alive, format: :json, xhr: true

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
