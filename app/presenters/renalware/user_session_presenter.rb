module Renalware
  class UserSessionPresenter
    # Returns a hash to be splatted into the body attributes in a layout e.g. application.html.slim
    # e.g.
    #
    #  body(class="..." *Renalware::UserSessionPresenter.session_controller_data_attributes)
    #
    # renders:
    #
    # <body class="..."
    #       data-controller="session"
    #       data-session-check-alive-path="/check_session_expired"
    #       data-session-debug="true"
    #       data-session-keep-alive-path="/keep_session_alive"
    #       data-session-login-path="/users/sign_in"
    #       data-session-polling-interval="60"
    #       data-session-timeout="3600">
    def self.session_controller_data_attributes
      urls = Renalware::Engine.routes.url_helpers
      {
        data: {
          controller: "session",
          session: {
            "login-path": urls.new_user_session_path,
            "check-alive-path": urls.check_session_expired_path,
            "keep-alive-path": urls.keep_session_alive_path,
            debug: Rails.env.development?.to_s, # eg "true" or "false"
            "register-user-activity-after":
              Renalware.config.session_register_user_user_activity_after.to_i,
            timeout: ::Devise.timeout_in
          }
        }
      }
    end
  end
end
