module Renalware
  module Concerns
    module LdapErrorHandler
      extend ActiveSupport::Concern

      included { rescue_from(Ldap::Error, with: :handle_ldap_error) }

      private

      def handle_ldap_error(exception)
        log_ldap_error(exception)
        redirect_back fallback_location: login_path_fallback, alert: ldap_error_message
      end

      def log_ldap_error(exception)
        exception_msg = "#{exception.class} - #{exception.message}"
        context = "in #{controller_name}##{action_name}"

        Rails.logger.error("LDAP error #{context}: #{exception_msg}")
        Rails.logger.error(exception.backtrace.join("\n"))
      end

      def ldap_error_message
        I18n.t("renalware.system.errors.ldap.service_unavailable")
      end

      def login_path_fallback
        return new_user_session_path if respond_to?(:new_user_session_path)
        return main_app.new_user_session_path if respond_to?(:main_app) &&
                                                 main_app.respond_to?(:new_user_session_path)

        "/users/sign_in"
      end
    end
  end
end
