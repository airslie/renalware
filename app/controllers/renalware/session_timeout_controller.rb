module Renalware
  class SessionTimeoutController < BaseController
    skip_before_action :track_ahoy_visit
    protect_from_forgery only: []
    after_action :track_action, only: []

    # Invoked by session_controller.js during user activity.
    # Returning a server-computed expiry allows the client to run a local timer
    # without dedicated expiry polling.
    def keep_session_alive
      skip_authorization # pundit
      render json: { expires_at_epoch_ms: current_session_expires_at_epoch_ms }
    end

    private

    def current_session_expires_at_epoch_ms
      last_request_at = user_session&.[]("last_request_at")
      last_request_time = if last_request_at.present?
                            Time.zone.at(last_request_at.to_i)
                          else
                            Time.zone.now
                          end
      (last_request_time + ::Devise.timeout_in).to_i * 1000
    end
  end
end
