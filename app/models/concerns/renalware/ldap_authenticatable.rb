module Renalware
  module LdapAuthenticatable
    extend ActiveSupport::Concern

    RENALWARE_GROUP = "cn=renalware,ou=groups,dc=renalware,dc=app".freeze

    def valid_password?(password)
      if ldap_enabled?
        valid_ldap_authentication?(password)
      else
        super
      end
    end

    def ldap_before_save
      return unless ldap_enabled?

      self.email = ldap_param("mail")
      self.given_name = ldap_param("givenName")
      self.family_name = ldap_param("sn")
      self.approved = true
    end

    def assign_ldap_role
      return unless ldap_enabled?

      role_name = in_renalware_group? ? :clinical : :read_only
      role = Role.find_by!(name: role_name)
      roles << role
    end

    private

    def ldap_enabled?
      Renalware.config.ldap_authentication
    end

    def ldap_param(attribute)
      ::Devise::LDAP::Adapter.get_ldap_param(username, attribute).first
    end

    def in_renalware_group?
      ::Devise::LDAP::Adapter.in_ldap_group?(username, RENALWARE_GROUP)
    rescue StandardError => e
      Rails.logger.error "LDAP group check failed for user #{username}: #{e.message}"
      false
    end
  end
end
