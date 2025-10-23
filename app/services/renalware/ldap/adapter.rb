module Renalware
  module Ldap
    # Adapter for LDAP operations with error handling
    # Uses our own Connection class (no longer depends on devise_ldap_authenticatable gem)
    class Adapter
      def valid_credentials?(username, password)
        connection = Connection.new(username: username, password: password)
        connection.valid_credentials?
      rescue Net::LDAP::Error => e
        raise Error, "#{e.class}: #{e.message}", cause: e
      end

      def param(username, attribute)
        connection = Connection.new(username: username)
        connection.param(attribute)&.first
      rescue Net::LDAP::Error => e
        raise Error, "#{e.class}: #{e.message}", cause: e
      end

      def user_in_group?(username, group_dn)
        connection = Connection.new(username: username)
        # "member" is the standard LDAP attribute for group membership
        connection.in_group?(group_dn, "member")
      rescue Net::LDAP::Error => e
        raise Error, "#{e.class}: #{e.message}", cause: e
      end
    end
  end
end
