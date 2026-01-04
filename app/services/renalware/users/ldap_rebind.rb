# frozen_string_literal: true

require "net/ldap"

module Renalware
  class Users::LdapRebind
    # Returns true if the username and password are valid according to LDAP
    def self.verify_password!(username:, password:) # rubocop:disable Metrics/MethodLength
      return false if username.blank? || password.blank?

      ldap = Net::LDAP.new(
        host: Renalware.config.ldap_host,
        port: Renalware.config.ldap_port,
        encryption: {
          method: :simple_tls,
          tls_options: { verify_mode: Renalware.config.ldap_verify_mode }
        },
        auth: {
          method: :simple,
          username: user_bind_name(username),
          password: password
        }
      )

      ldap.bind
    rescue Net::LDAP::Error
      false
    end

    def self.user_bind_name(username) = "#{username}@#{Renalware.config.ldap_user_upn_suffix}"
    private_class_method :user_bind_name
  end
end
