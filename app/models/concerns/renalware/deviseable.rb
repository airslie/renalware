require "active_support/concern"

# Concern for Devise enhancements
# eg. User approval and password expiry
#
module Renalware
  module Deviseable
    extend ActiveSupport::Concern

    included do
      class_eval do
        modules = %i(
          expirable
          registerable
          lockable
          rememberable
          trackable
          validatable
          timeoutable
        )

        # Having conditional modules makes testing really hard. This is because
        # once the models are loaded you can't switch them on/off. This was
        # highlighted when attempting to disable LDAP authentication for devops
        # users. This meant reintroducing database_authenticatable and that
        # meant it conflicted with the LDAP module.
        # From the LDAP Authenticatable docs:
        # | This devise plugin has not been tested with DatabaseAuthenticatable
        # | enabled at the same time
        # Specifically, calling `super` in `valid_password?` causes the LDAP
        # `valid_password?` method to be called instead of the database one.
        #
        # My recommendation is to have all modules loaded unconditionally and
        # then turn off what's needed with flags. E.g. recoverable doesn't show
        # if DEVISE_USER_RECOVERABLE=false and relevant controllers are disabled.
        #
        # LDAP Authenticatable is 5 years old so probably better to use the bits
        # that are needed it works differently to how we're using it.
        if Renalware.config.ldap_authentication
          modules << :ldap_authenticatable
        else
          modules << :database_authenticatable
          modules << :recoverable
        end
        devise(*modules)
      end

      # Makes the User 'approvable'
      # See https://github.com/plataformatec/devise/wiki/How-To:-Require-admin-to-activate-account-before-sign_in
      def active_for_authentication?
        super && approved? && !banned
      end

      def inactive_message
        if banned?
          :banned
        elsif approved?
          super
        elsif ldap_requires_manual_approval?
          :not_approved_ldap
        else
          :not_approved
        end
      end
    end
  end
end
