# Custom LDAP authentication module for Devise
# Supports auto-creation of users on first login and group-based authorization
module Devise
  module Models
    module LdapAuthenticatable
      extend ActiveSupport::Concern

      included do
        validate :ldap_group_membership, on: :create, if: :ldap_enabled?
      end

      class_methods do
        delegate :info, :debug, :error, to: ::Renalware::Ldap::Logger

        # Custom implementation for finding/creating users from LDAP authentication
        # Supports authorization errors and auto-creation of users on first login
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

          if resource.new_record? && resource.valid_ldap_authentication?(attributes[:password])
            resource.ldap_before_save if resource.respond_to?(:ldap_before_save)
            unless resource.save
              error_messages = resource.errors.full_messages.join(", ")
              error("Error saving new user #{resource.username}: #{error_messages}")
            end
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

        mappings = Renalware.config.ldap_attribute_mappings
        self.email = ldap_param(mappings["email"])
        self.given_name = ldap_param(mappings["given_name"])
        self.family_name = ldap_param(mappings["family_name"])
        self.approved = Renalware.config.ldap_auto_approve_users if in_valid_ldap_group?
      end

      def assign_ldap_role
        ldap_role_synchronizer.assign_role(self)
      end

      def synchronize_ldap_roles
        ldap_role_synchronizer.synchronize_roles(self)
      end

      def valid_ldap_authentication?(password)
        ldap_adapter.valid_credentials?(username, password)
      end

      def ldap_requires_manual_approval?
        ldap_enabled? && !Renalware.config.ldap_auto_approve_users
      end

      def in_valid_ldap_group?
        in_renalware_group? || in_renalware_readonly_group?
      end

      private

      def ldap_enabled?
        Renalware.config.ldap_authentication
      end

      def ldap_adapter
        @ldap_adapter ||= Renalware::Ldap::Adapter.new
      end

      def ldap_role_synchronizer
        @ldap_role_synchronizer ||= Renalware::Ldap::RoleSynchronizer.new
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

      def ldap_group_membership
        return if in_valid_ldap_group?

        errors.add(:base, "You are not authorised to access this system")
      end
    end
  end
end
