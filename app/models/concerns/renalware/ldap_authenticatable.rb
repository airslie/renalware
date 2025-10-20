module Renalware
  module LdapAuthenticatable
    extend ActiveSupport::Concern

    ADMIN_LEVEL_ROLES = %w(super_admin admin devops).freeze

    included do
      validate :ldap_group_membership, on: :create, if: :ldap_enabled?
    end

    class_methods do
      # This is lifted from devise_ldap_authenticatable gem and modified to
      # support authorization errors.
      # It might be worth pushing this into a fork of devise_ldap_authenticatable.
      # The gem is not maintained and could probably support more use cases
      # but maybe someone will find it useful particualrly if we're rolling this
      # out to other hospitals.
      #
      # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/MethodLength, Metrics/PerceivedComplexity
      def find_for_ldap_authentication(attributes = {})
        auth_key = authentication_keys.first
        return nil if attributes[auth_key].blank?

        auth_key_value = if (case_insensitive_keys || []).include?(auth_key)
                           attributes[auth_key].downcase
                         else
                           attributes[auth_key]
                         end
        auth_key_value = auth_key_value.strip if (strip_whitespace_keys || []).include?(auth_key)

        resource = where(auth_key => auth_key_value).first

        if resource.blank?
          resource = new
          resource[auth_key] = auth_key_value
          resource.password = attributes[:password]
        end

        if ::Devise.ldap_create_user && resource.new_record? &&
           resource.valid_ldap_authentication?(attributes[:password])
          resource.ldap_before_save if resource.respond_to?(:ldap_before_save)
          resource.save
        end

        resource
      end
      # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/MethodLength, Metrics/PerceivedComplexity
    end

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
      self.given_name = ldap_param("givenName") || ldap_param("cn")
      self.family_name = ldap_param("sn")
      self.approved = Renalware.config.ldap_auto_approve_users if in_valid_ldap_group?
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

      if expected_role.nil?
        remove_ldap_roles

        # TODO: Don't do this as user will end up in a list to be approved
        return update(approved: false)
      end

      return if current_base_role == expected_role

      update_base_role(current_base_role, expected_role)
    end

    def valid_ldap_authentication?(password)
      ldap_adapter.valid_credentials?(username, password)
    end

    def ldap_requires_manual_approval?
      ldap_enabled? && !Renalware.config.ldap_auto_approve_users
    end

    private

    def ldap_enabled?
      Renalware.config.ldap_authentication
    end

    def ldap_adapter
      @ldap_adapter ||= Ldap::Adapter.new
    end

    def ldap_param(attribute)
      ldap_adapter.param(username, attribute)
    end

    def in_ldap_group?(group)
      ldap_adapter.user_in_group?(username, group)
    end

    def in_renalware_group?
      in_ldap_group?(Renalware.config.ldap_clinical_group)
    end

    def in_renalware_readonly_group?
      in_ldap_group?(Renalware.config.ldap_readonly_group)
    end

    def admin_level_user?
      role_names.intersect?(ADMIN_LEVEL_ROLES)
    end

    def in_valid_ldap_group?
      in_renalware_group? || in_renalware_readonly_group?
    end

    def ldap_role_for_user
      return :clinical if in_renalware_group?

      :read_only if in_renalware_readonly_group?
    end

    def current_permission_role
      return :clinical if role_names.include?("clinical")

      :read_only if role_names.include?("read_only")
    end

    def ldap_roles
      %w(clinical read_only)
    end

    def remove_ldap_roles
      ldap_role_records = Role.where(name: ldap_roles)
      roles.delete(ldap_role_records)
    end

    def update_base_role(old_role, new_role)
      return unless old_role

      old_role_record = Role.find_by(name: old_role)
      new_role_record = Role.find_by!(name: new_role)

      roles.delete(old_role_record) if old_role_record
      roles << new_role_record unless roles.include?(new_role_record)
    end

    def ldap_group_membership
      return if in_valid_ldap_group?

      errors.add(:base, "You are not authorised to access this system")
    end
  end
end
