require "devise/strategies/database_authenticatable"

module Devise
  module Strategies
    # This strategy overrides the default :database_authenticatable strategy
    # to only authenticate if not using LDAP
    class RenalwareDatabaseAuthenticatable < DatabaseAuthenticatable
      def authenticate!
        return if Renalware.config.ldap_authentication

        super
      end
    end
  end
end

Warden::Strategies.add(:database_authenticatable, Devise::Strategies::RenalwareDatabaseAuthenticatable)
