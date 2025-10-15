module Renalware
  module Ldap
    class Adapter
      def valid_credentials?(username, password)
        ::Devise::LDAP::Adapter.valid_credentials?(username, password)
      rescue Net::LDAP::Error, DeviseLdapAuthenticatable::LdapException => e
        raise Error, "#{e.class}: #{e.message}", cause: e
      end

      def param(username, attribute)
        ::Devise::LDAP::Adapter.get_ldap_param(username, attribute)&.first
      rescue Net::LDAP::Error, DeviseLdapAuthenticatable::LdapException => e
        raise Error, "#{e.class}: #{e.message}", cause: e
      end

      def user_in_group?(username, group_dn)
        # "member" is the standard LDAP attribute for group membership
        ::Devise::LDAP::Adapter.in_ldap_group?(username, group_dn, "member")
      rescue Net::LDAP::Error, DeviseLdapAuthenticatable::LdapException => e
        raise Error, "#{e.class}: #{e.message}", cause: e
      end
    end
  end
end
