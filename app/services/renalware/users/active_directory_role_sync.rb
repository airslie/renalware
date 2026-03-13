module Renalware
  module Users
    class ActiveDirectoryRoleSync
      def initialize(user:, ad_roles:)
        @user = user
        @ad_roles = ad_roles
      end

      def call
        remove_roles(current_roles - desired_roles)
        add_roles(desired_roles - current_roles)
      end

      private

      attr_reader :user, :ad_roles

      # aka desired managed roles
      def desired_roles
        @desired_roles ||= managed_roles.select do |role|
          normalized_ad_roles.include?(normalize_role_name(role.ad_role_name))
        end
      end

      # aka current managed roles
      def current_roles
        @current_roles ||= user.roles.select { |role| managed_roles.include?(role) }
      end

      def managed_roles
        @managed_roles ||= Role.where.not(ad_role_name: nil).to_a
      end

      def normalized_ad_roles
        @normalized_ad_roles ||= Array(ad_roles).filter_map do |role_name|
          normalize_role_name(role_name)
        end
      end

      # rubocop:disable Style/SafeNavigationChainLength
      def normalize_role_name(role_name)
        role_name
          &.downcase
          &.split(",")
          &.first
          &.delete_prefix("cn=")
      end
      # rubocop:enable Style/SafeNavigationChainLength

      def add_roles(roles)
        roles.each { |role| user.roles << role }
      end

      def remove_roles(roles)
        roles.each { |role| user.roles.delete(role) }
      end
    end
  end
end
