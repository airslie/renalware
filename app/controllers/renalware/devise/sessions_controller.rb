module Renalware
  class Devise::SessionsController < ::Devise::SessionsController
    include Concerns::DeviseControllerMethods

    # Define the path to go to after logging in:
    # - if the user has never before logged-in, devise will take them to the root path (dashboard)
    # - if the user's session timed-out less that 30 minutes ago, we take them back to the
    #    last page they were on.
    # - if the user's session timed-out more than 30 minutes ago, we take them back to the
    #    their dashboard. See PR #1592 for rationale.
    # - if the user has explicitly logged-out they will always go the the dashboard path on login,
    #   regardless of how long ago they signed out, because in this instance devise removes it's
    #   entries in the session cookie.
    def after_sign_in_path_for(resource)
      track_signin
      max_duration_of_url_memory = Renalware.config.duration_of_last_url_memory_after_session_expiry
      max_duration_has_passed = last_sign_in_at <= max_duration_of_url_memory.ago
      max_duration_has_passed ? dashboard_path : super
    end

    private

    def last_sign_in_at
      current_user.last_sign_in_at || epoch_start
    end

    def epoch_start
      Date.new(0)
    end

    def track_signin
      ahoy.track "signin"
    end
  end
end
