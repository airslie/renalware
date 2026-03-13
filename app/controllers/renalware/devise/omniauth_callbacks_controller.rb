module Renalware
  module Devise
    # rubocop:disable Rails/I18nLocaleTexts
    class OmniauthCallbacksController < ::Devise::OmniauthCallbacksController
      # Callback for LDAP OmniAuth strategy
      def entra_id
        auth = request.env["omniauth.auth"]
        @user = User.from_entra_id_omniauth(auth)

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "Microsoft") if is_navigational_format?
        else
          session["devise.entra_id_data"] = auth.except("extra")
          redirect_to new_user_session_path, alert: "Could not sign in with Microsoft."
        end
      end

      # Callback for LDAP OmniAuth strategy
      def ldap
        auth = request.env["omniauth.auth"]
        @user = User.from_ldap_omniauth(auth, request.params["password"])

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "LDAP") if is_navigational_format?
        else
          session["devise.ldap_data"] = auth.except("extra")
          redirect_to new_user_session_path, alert: "Could not sign in with LDAP."
        end
      rescue => e # rubocop:disable Style/RescueStandardError
        Rails.logger.warn("LDAP login failed: #{e.class}: #{e.message}")
        redirect_to new_user_session_path, alert: "LDAP sign-in failed."
      end

      # Failure callback for all omniauth strategies
      def failure # rubocop:disable Metrics/MethodLength
        strategy   = request.env["omniauth.strategy"]&.name.to_s
        error_type = request.env["omniauth.error.type"] # e.g. :invalid_credentials

        if strategy == "ldap"
          if error_type == :invalid_credentials
            username = request.params["username"] # from your LDAP login form
            # Because LDAP invalid credentials (49) can mean several things, we try
            # fetch extended info to give a better error message.
            # For example, account disabled, locked, etc.
            specific = enrich_ldap_invalid_credentials(username)
            if specific
              flash[:alert] = I18n.t("devise.failure.#{specific}")
            else
              set_flash_message!(:alert, :invalid, authentication_keys: "username")
            end
          else
            flash[:alert] = "LDAP sign-in failed."
          end

          redirect_to new_user_session_path
          return
        end

        super
      end

      private

      def enrich_ldap_invalid_credentials(username) # rubocop:disable Metrics/MethodLength
        ldap = Net::LDAP.new(
          host: ENV.fetch("LDAP_HOST"),
          port: 636,
          encryption: {
            method: :simple_tls,
            tls_options: { verify_mode: OpenSSL::SSL::VERIFY_NONE } # your current dev stance
          },
          auth: {
            method: :simple,
            username: ENV.fetch("LDAP_ADMIN_USER"),
            password: ENV.fetch("LDAP_ADMIN_PASSWORD")
          }
        )

        filter = Net::LDAP::Filter.eq("sAMAccountName", username)
        entry = ldap.search(
          base: ENV.fetch("LDAP_BASE"),
          filter:,
          attributes: %w(userAccountControl lockoutTime pwdLastSet)
        ).first
        return nil unless entry

        uac = entry[:useraccountcontrol].first.to_i
        # ACCOUNTDISABLE flag is 0x0002
        disabled = (uac & 0x0002) != 0 # rubocop:disable Style/BitwisePredicate
        lockout_time = entry[:lockouttime].first.to_i
        locked = lockout_time != 0

        return :account_disabled if disabled
        return :account_locked if locked

        nil
      end
    end
    # rubocop:enable Rails/I18nLocaleTexts
  end
end
