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
    #       data-session-debug="true"
    #       data-session-expires-at-epoch-ms="1744300427000"
    #       data-session-keep-alive-path="/keep_session_alive"
    #       data-session-login-path="/users/sign_in"
    #       data-session-timeout="3600">
    def self.session_controller_data_attributes(user_session:)
      urls = Renalware::Engine.routes.url_helpers
      {
        data: {
          controller: "session",
          session: {
            "login-path": urls.new_user_session_path,
            "expires-at-epoch-ms": session_expires_at_epoch_ms(user_session),
            "keep-alive-path": urls.keep_session_alive_path,
            debug: Rails.env.development?.to_s, # eg "true" or "false"
            "register-user-activity-after":
              Renalware.config.session_register_user_user_activity_after.to_i,
            timeout: ::Devise.timeout_in
          }
        }
      }
    end

    def self.session_expires_at_epoch_ms(user_session)
      last_request_at = extract_last_request_at(user_session)
      return if last_request_at.blank?

      ((Time.zone.at(last_request_at.to_i) + ::Devise.timeout_in).to_f * 1000).to_i
    end

    # rubocop:disable Style/QuotedSymbols
    def self.extract_last_request_at(user_session)
      return if user_session.blank?

      user_session["last_request_at"] ||
        user_session[:last_request_at] ||
        user_session.dig("warden.user.user.session", "last_request_at") ||
        user_session.dig(:'warden.user.user.session', "last_request_at") ||
        user_session.dig("warden.user.user.session", :last_request_at) ||
        user_session.dig(:'warden.user.user.session', :last_request_at)
    end
    # rubocop:enable Style/QuotedSymbols
  end
end
