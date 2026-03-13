require "active_support/concern"

# Concern for Devise enhancements
# eg. User approval and password expiry
#
module Renalware
  module Deviseable
    extend ActiveSupport::Concern

    included do
      class_eval do
        devise(
          :database_authenticatable,
          :expirable,
          :lockable,
          :rememberable,
          :trackable,
          :validatable,
          :registerable,
          :timeoutable,
          :omniauthable,
          omniauth_providers: [:entra_id, :ldap]
        )

        # Password recovery (forgot password) is only enabled for database auth,
        # since LDAP users manage their passwords via LDAP.
        # Advise we enable this statically to a) make it easier to test and b)
        # to allow for future scenarios where database auth needs to be used fro
        # certain users even when LDAP is enabled.
        devise(:recoverable) unless Renalware.config.ldap_authentication

        # We also add any hospital-specific modules that have been configured
        devise(*Renalware.config.devise_extra_modules) if Renalware.config.devise_extra_modules.any?
      end

      # Makes the User 'approvable'
      # See https://github.com/plataformatec/devise/wiki/How-To:-Require-admin-to-activate-account-before-sign_in
      def active_for_authentication?
        super && approved? && !banned
      end

      def inactive_message
        if banned?
          :banned
        elsif !new_record? && !approved?
          manual_ldap_approval_required? ? :not_approved_ldap : :not_approved
        elsif approved?
          super
        else
          :not_approved
        end
      end

      def valid_password?(password)
        if ldap_authentication_enabled?
          ldap_connection(password).valid_credentials?
        else
          super
        end
      end

      private

      def ldap_authentication_enabled?
        Renalware.config.ldap_authentication
      end

      def ldap_connection(password = nil)
        Renalware::Ldap::Connection.new(username:, password:)
      end

      def manual_ldap_approval_required?
        ldap_authentication_enabled? && !Renalware.config.ldap_auto_approve_users
      end
    end
  end
end
