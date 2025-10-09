module Renalware
  module Concerns
    module LdapErrorHandler
      extend ActiveSupport::Concern

      included do
        rescue_from(
          Net::LDAP::Error,
          DeviseLdapAuthenticatable::LdapException,
          with: :handle_ldap_error
        )
      end

      private

      def log_ldap_error(exception)
        exception_msg = "#{exception.class} - #{exception.message}"
        context = "in #{controller_name}##{action_name}"

        Rails.logger.error("LDAP error #{context}: #{exception_msg}")
        Rails.logger.error(exception.backtrace.join("\n"))
      end

      def ldap_error_message
        I18n.t("renalware.system.errors.ldap.service_unavailable")
      end
    end
  end
end
