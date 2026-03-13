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

      top_level = safe_fetch(user_session, "last_request_at") ||
                  safe_fetch(user_session, :last_request_at)
      return top_level if top_level.present?

      safe_dig(user_session, "warden.user.user.session", "last_request_at") ||
        safe_dig(user_session, :'warden.user.user.session', "last_request_at") ||
        safe_dig(user_session, "warden.user.user.session", :last_request_at) ||
        safe_dig(user_session, :'warden.user.user.session', :last_request_at)
    end
    # rubocop:enable Style/QuotedSymbols

    def self.safe_fetch(object, key)
      object[key] if object.respond_to?(:[])
    rescue StandardError
      nil
    end

    def self.safe_dig(object, *keys)
      object.dig(*keys) if object.respond_to?(:dig)
    rescue StandardError
      nil
    end
  end
end
