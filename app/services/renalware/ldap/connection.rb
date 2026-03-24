require "net/ldap"

module Renalware
  module Ldap
    class Connection
      delegate :info, :error, to: ::Renalware::Ldap::Logger

      attr_reader :username

      def initialize(username:, password: nil)
        @username = username
        @password = password
      end

      def valid_credentials?
        return false if @password.blank?

        !bind.nil?
      end

      def nested_group_names(group_names:)
        return [] if group_names.blank?

        dn = search_for_user&.dn
        return [] if dn.blank?

        entries = []
        admin_ldap.search(filter: nested_groups_filter(user_dn: dn, group_names:)) do |found_entry|
          entries << found_entry
        end

        log_failure(admin_ldap, raise_on_error: true)

        entries.filter_map { |entry| entry["cn"]&.first || entry[:cn]&.first }
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
          encryption: :simple_tls
        )
      end

      def admin_ldap
        return @admin_ldap if @admin_ldap

        connection = self.class.new(
          username: config.ldap_admin_user,
          password: config.ldap_admin_password
        )
        @admin_ldap = connection.send(:bind, use_user_dn: false)

        return @admin_ldap if @admin_ldap

        raise Error, "Cannot bind to LDAP server with admin credentials"
      end

      def user_dn
        @user_dn ||= begin
          entry = search_for_user
          dn = if entry
                 entry.dn
               else
                 # Fallback: construct DN from config
                 username_attr = config.ldap_attribute_mappings["username"]
                 "#{username_attr}=#{@username},#{config.ldap_base}"
               end
          info("dn lookup: #{dn}")
          dn
        end
      end

      def search_for_user
        @search_for_user ||= begin
          username_attr = config.ldap_attribute_mappings["username"]
          filter = Net::LDAP::Filter.eq(username_attr, Net::LDAP::Filter.escape(@username))
          info("search for user: #{username_attr}=#{@username}")

          entries = []
          admin_ldap.search(filter: filter) do |found_entry|
            entries << found_entry
          end

          log_failure(admin_ldap, raise_on_error: true)
          info("search yielded #{entries.size} matches")

          entries.first
        end
      end

      def bind(use_user_dn: true)
        ldap.auth(use_user_dn ? user_dn : username, password)
        if ldap.bind
          info("Valid credentials for user: #{username}")
          ldap
        else
          log_failure(ldap)
          nil
        end
      end

      def log_failure(ldap_connection, raise_on_error: false)
        result = ldap_connection.get_operation_result
        return if result.code.zero?

        message = "operation failed: #{result.code} - #{result.message}"
        error(message)
        raise Error, message if raise_on_error
      end

      def nested_groups_filter(user_dn:, group_names:)
        group_filter = case group_names.length
                       when 1
                         "(cn=#{escape_filter_value(group_names.first)})"
                       else
                         "(|#{group_names.map { |name| "(cn=#{escape_filter_value(name)})" }.join})"
                       end

        Net::LDAP::Filter.construct(
          "(&(objectClass=group)" \
          "(member:1.2.840.113556.1.4.1941:=#{escape_filter_value(user_dn)})" \
          "#{group_filter})"
        )
      end

      def escape_filter_value(value)
        Net::LDAP::Filter.escape(value.to_s)
      end
    end
  end
end
