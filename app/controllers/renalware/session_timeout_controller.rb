# This controller exposes a check_session_expired action which is invoked via Ajax on a JavaScript
# timer and will cause the user to be redirected to the login page if their session has expired
# due to a period of activity. The redirect happens because of a generic Ajax error handling
# JavaScript - see ajax_errors.js - which causes the page to reload after any Ajax 401 error
# thus causing a redirect to the login page in the usual Rails way (i.e. as if the user had tried
# to refresh the page or attempt some action after devise had logged them out on the server).
#
# Inspired by this SO post: https://stackoverflow.com/questions/17791626
#
module Renalware
  class SessionTimeoutController < BaseController
    prepend_before_action :skip_timeout, only: :check_session_expired
    skip_before_action :authenticate_user!, only: :check_session_expired
    skip_before_action :track_ahoy_visit
    protect_from_forgery only: []
    after_action :track_action, only: []

    # Note this action will NOT update the session activity (thus keeping the session alive)
    # because we invoke #skip_timeout at the beginning of the filter chain.
    # We could return the amount of time remaining before the session expires like so
    #   time_left = Devise.timeout_in - (Time.now - user_session["last_request_at"]).round
    # and display this to the user if required.
    def check_session_expired
      skip_authorization # pundit
      if referrer_is_a_devise_url? || !current_users_session_has_timed_out?
        head :ok
      else
        head :unauthorized
      end
    end

    # session_controller.js invoked this action to when there is user activity on the page
    # to update the session window.
    # Note this will keep the session alive because we have NOT invoked skip_timeout before the
    # action, so, like all controller actions, the user's last_request_at time stamp is
    # updated in their session cookie.
    def keep_session_alive
      skip_authorization # pundit
      if referrer_is_a_devise_url? || !current_users_session_has_timed_out?
        head :ok
      else
        head :unauthorized
      end
    end

    private

    def skip_timeout
      request.env["devise.skip_trackable"] = true
    end

    def current_users_session_has_timed_out?
      return true if user_session.blank?

      last_request_at = Time.zone.at(user_session["last_request_at"])
      !current_user || current_user.timedout?(last_request_at)
    end

    # Returns a truthy value if we came from a devise URL like users/sign_in
    def referrer_is_a_devise_url?
      referrer = request.referer
      return if request.blank? || referrer.blank?

      regex_defining_devise_paths = %r{(#{new_user_session_path}|users\/password|users\/sign_up)}
      URI.parse(referrer).path =~ regex_defining_devise_paths
    end
  end
end
