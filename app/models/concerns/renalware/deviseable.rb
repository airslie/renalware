require "active_support/concern"

# Concern for Devise enhancements
# eg. User approval and password expiry
#
module Renalware
  module Deviseable
    extend ActiveSupport::Concern

    included do
      class_eval do
        # Both database_authenticatable and ldap_authenticatable modules are
        # always loaded to provide model methods. Each has a corresponding
        # Warden strategy that checks Renalware.config.ldap_authentication
        # to determine which authentication method to use at runtime.
        # See:
        # - lib/devise/strategies/renalware_database_authenticatable.rb
        # - lib/devise/strategies/ldap_authenticatable.rb
        devise(
          :database_authenticatable,
          :ldap_authenticatable,
          :expirable,
          :lockable,
          :rememberable,
          :trackable,
          :validatable,
          :registerable,
          :timeoutable,
          :omniauthable,
          omniauth_providers: [:entra_id]
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
          ldap_requires_manual_approval? ? :not_approved_ldap : :not_approved
        elsif approved?
          super
        else
          :not_approved
        end
      end
    end
  end
end
