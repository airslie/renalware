require "net/ldap"

module Renalware
  module Ldap
    class Connection
      delegate :info, :debug, :error, to: ::Renalware::Ldap::Logger

      attr_reader :username

      def initialize(username:, password: nil)
        @username = username
        @password = password
      end

      def valid_credentials?
        return false if @password.blank?

        !bind.nil?
      end

      def log(result, message: "Operation failed", negative: "not ")
        message = message.gsub(negative, "") if result
        debug(message)
      end

      def param(attribute)
        entry = search_for_user
        return unless entry

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

        info("User #{user_dn} is #{'not ' unless in_group}in group: #{group_dn}")

        in_group
      end

      def user_dn
        @user_dn ||= begin
          entry = search_for_user
          dn = if entry
                 entry.dn
               else
                 # Fallback: construct DN from config
                 "#{config.ldap_username_attribute}=#{@username},#{config.ldap_base}"
               end
          debug("dn lookup: #{dn}")
          dn
        end
      end

      def search_for_user
        @search_for_user ||= begin
          filter = Net::LDAP::Filter.eq(config.ldap_username_attribute, @username)
          debug("search for user: #{config.ldap_username_attribute}=#{@username}")

          entries = []
          ldap.search(filter: filter) do |found_entry|
            entries << found_entry
          end

          check_operation_result!(ldap)
          debug("search yielded #{entries.size} matches")

          entries.first
        end
      end

      def bind(use_user_dn: true)
        ldap.auth(use_user_dn ? user_dn : username, password)
        if ldap.bind
          info("Valid credentials for user: #{username}")
          ldap
        else
          info("Invalid credentials for user: #{username}")
          nil
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

        raise Error, "LDAP operation failed: #{result.message}"
      end
    end
  end
end
