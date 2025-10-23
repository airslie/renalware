require "net/ldap"

module Renalware
  module Ldap
    class Connection
      attr_reader :username

      def initialize(username:, password: nil)
        @username = username
        @password = password
      end

      def valid_credentials?
        return false if @password.blank?

        !!bind
      end

      def param(attribute)
        entry = search_for_user
        return nil unless entry
        return nil if entry[attribute].empty?

        entry[attribute]
      end

      # group_dn: Full DN of the group (e.g., "cn=clinical,ou=groups,dc=renalware,dc=app")
      # group_attribute: Attribute that contains group members (default: "member")
      def in_group?(group_dn, group_attribute = "member")
        in_group = false

        admin_ldap.search(
          base: group_dn,
          scope: Net::LDAP::SearchScope_BaseObject
        ) do |entry|
          in_group = true if entry[group_attribute].include?(user_dn)
        end

        check_operation_result!(admin_ldap)
        in_group
      end

      def user_dn
        @user_dn ||= begin
          entry = search_for_user
          if entry
            entry.dn
          else
            # Fallback: construct DN from config
            "#{config.ldap_username_attribute}=#{@username},#{config.ldap_base}"
          end
        end
      end

      def search_for_user
        @search_for_user ||= begin
          filter = Net::LDAP::Filter.eq(config.ldap_username_attribute, @username)
          entry = nil

          ldap.search(filter: filter) do |found_entry|
            entry = found_entry
            break
          end

          check_operation_result!(ldap)
          entry
        end
      end

      private

      attr_reader :password

      def config
        @config ||= Renalware.config
      end

      def ldap
        @ldap ||= Net::LDAP.new(
          host: config.ldap_host,
          port: config.ldap_port,
          base: config.ldap_base,
          encryption: config.ldap_ssl ? :simple_tls : nil
        )
      end

      def bind(use_user_dn: true)
        ldap.auth(use_user_dn ? user_dn : username, password)
        ldap if ldap.bind
      end

      def admin_ldap
        return @admin_ldap if @admin_ldap

        @admin_ldap = self.class.new(
          username: config.ldap_admin_user,
          password: config.ldap_admin_password
        ).bind(use_user_dn: false)

        return @admin_ldap if @admin_ldap

        raise Error, "Cannot bind to LDAP server with admin credentials"
      end

      def check_operation_result!(ldap_connection)
        result = ldap_connection.get_operation_result
        return if result.code.zero?

        Rails.logger.error("LDAP operation failed: #{result.code} - #{result.message}")
        raise Error, "LDAP operation failed: #{result.message}"
      end
    end
  end
end
