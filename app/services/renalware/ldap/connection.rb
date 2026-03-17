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
    end
  end
end
