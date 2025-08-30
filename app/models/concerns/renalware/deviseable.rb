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
        else
          :not_approved
        end
      end
    end
  end
end
