module Renalware
  module LdapAuthenticatable
    extend ActiveSupport::Concern

    RENALWARE_GROUP = "cn=renalware,ou=groups,dc=renalware,dc=app".freeze
    RENALWARE_READONLY_GROUP = "cn=renalware-readonly,ou=groups,dc=renalware,dc=app".freeze
    ADMIN_LEVEL_ROLES = %w(super_admin admin devops).freeze

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
      self.approved = in_valid_ldap_group?
    end

    def assign_ldap_role
      return unless ldap_enabled?

      role_name = ldap_role_for_user
      return unless role_name

      role = Role.find_by!(name: role_name)
      roles << role
    end

    def synchronize_ldap_roles
      return unless ldap_enabled?
      return if admin_level_user?

      expected_role = ldap_role_for_user
      current_base_role = current_permission_role

      return update(approved: false) if expected_role.nil?
      return if current_base_role == expected_role

      update_base_role(current_base_role, expected_role)
    rescue StandardError => e
      Rails.logger.error "Failed to synchronize LDAP roles for user #{username}: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      update(approved: false)
    end

    private

    def valid_ldap_authentication?(password)
      ::Devise::LDAP::Adapter.valid_credentials?(username, password)
    rescue StandardError => e
      Rails.logger.error "LDAP authentication failed for user #{username}: #{e.message}"
      false
    end

    def ldap_enabled?
      Renalware.config.ldap_authentication
    end

    def ldap_param(attribute)
      ::Devise::LDAP::Adapter.get_ldap_param(username, attribute).first
    end

    def in_ldap_group?(group)
      ::Devise::LDAP::Adapter.in_ldap_group?(username, group)
    rescue StandardError => e
      Rails.logger.error "LDAP group check failed for user #{username}: #{e.message}"
      false
    end

    def in_renalware_group?
      in_ldap_group?(RENALWARE_GROUP)
    end

    def in_renalware_readonly_group?
      in_ldap_group?(RENALWARE_READONLY_GROUP)
    end

    def admin_level_user?
      role_names.intersect?(ADMIN_LEVEL_ROLES)
    end

    def in_valid_ldap_group?
      in_renalware_group? || in_renalware_readonly_group?
    end

    def ldap_role_for_user
      return :clinical if in_renalware_group?
      return :read_only if in_renalware_readonly_group?

      nil
    end

    def current_permission_role
      return :clinical if role_names.include?("clinical")
      return :read_only if role_names.include?("read_only")

      nil
    end

    def update_base_role(old_role, new_role)
      return unless old_role

      old_role_record = Role.find_by(name: old_role)
      new_role_record = Role.find_by!(name: new_role)

      roles.delete(old_role_record) if old_role_record
      roles << new_role_record unless roles.include?(new_role_record)
    end
  end
end
