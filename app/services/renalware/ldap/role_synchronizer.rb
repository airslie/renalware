module Renalware
  module Ldap
    class RoleSynchronizer
      delegate :info, :debug, :error, to: ::Renalware::Ldap::Logger

      ADMIN_LEVEL_ROLES = %w(super_admin admin devops).freeze
      LDAP_ROLES = %w(clinical read_only).freeze

      def assign_role(user)
        return unless ldap_enabled?

        role_name = determine_role(user)
        unless role_name
          info("No role determined for user: #{user.username}")
          return
        end

        role = Role.find_by!(name: role_name)
        user.roles << role
        info("Assigned role #{role_name} to user: #{user.username}")
      end

      def skip_sync?(user)
        return false unless admin_level_user?(user)

        info("Skipping role sync for admin-level user: #{user.username}")
        true
      end

      def remove_roles?(user, role)
        return false unless role.nil?

        info("User #{user.username} not in any groups, removing roles")
        true
      end

      def synchronize_roles(user)
        return unless ldap_enabled?

        return if skip_sync?(user)

        expected_role = determine_role(user)
        current_role = current_base_role(user)

        debug("Role sync for #{user.username}: from=#{current_role}, to=#{expected_role}")

        return remove_roles(user) if remove_roles?(user, expected_role)

        return if current_role == expected_role

        info("Updating role for #{user.username}: #{current_role} -> #{expected_role}")
        update_role(user, current_role, expected_role)
      end

      def determine_role(user)
        return :clinical if in_renalware_group?(user)

        :read_only if in_renalware_readonly_group?(user)
      end

      def admin_level_user?(user)
        # Reload to ensure we have fresh data
        user.roles.reload.pluck(:name).intersect?(ADMIN_LEVEL_ROLES)
      end

      private

      def ldap_enabled?
        Renalware.config.ldap_authentication
      end

      def ldap_adapter
        @ldap_adapter ||= Adapter.new
      end

      def in_ldap_group?(user, group)
        ldap_adapter.user_in_group?(user.username, group)
      end

      def in_renalware_group?(user)
        in_ldap_group?(user, Renalware.config.ldap_clinical_group)
      end

      def in_renalware_readonly_group?(user)
        in_ldap_group?(user, Renalware.config.ldap_readonly_group)
      end

      def current_base_role(user)
        return :clinical if user.role_names.include?("clinical")

        :read_only if user.role_names.include?("read_only")
      end

      def remove_roles(user)
        ldap_role_records = Role.where(name: LDAP_ROLES)
        user.roles.delete(ldap_role_records)
      end

      def update_role(user, old_role, new_role)
        return unless old_role

        old_role_record = Role.find_by(name: old_role)
        new_role_record = Role.find_by!(name: new_role)

        user.roles.delete(old_role_record) if old_role_record
        user.roles << new_role_record unless user.roles.include?(new_role_record)
      end
    end
  end
end
