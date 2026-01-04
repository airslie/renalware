require "devise/strategies/authenticatable"

module Devise
  module Strategies
    # Custom LDAP authentication strategy for Renalware
    # Taken from https://github.com/airslie/devise_ldap_authenticatable which is
    # a fork of schlumpfit/devise_ldap_authenticatable.
    # Handles authorization errors and group-based access control
    class LdapAuthenticatable < Authenticatable
      delegate :info, :error, to: ::Renalware::Ldap::Logger

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
      def authenticate!
        return unless Renalware.config.ldap_authentication

        username = authentication_hash[:username]
        info("Auth attempt for user: #{username}")

        # This calls our own find_for_ldap_authentication method in
        # ldap_authenticatable concern.
        resource = mapping.to.find_for_ldap_authentication(
          authentication_hash.merge(password: password)
        )

        unless resource
          info("Auth failed: no resource found for #{username}")
          return fail(:invalid)
        end

        if resource.persisted?
          if validate(resource) { resource.valid_ldap_authentication?(password) }
            unless resource.in_valid_ldap_group?
              info("Auth failed: user #{username} not in valid group")
              return fail!(:not_authorized)
            end

            info("Auth successful for user: #{username}")
            remember_me(resource)
            success!(resource)
          else
            info("Auth failed: invalid credentials for #{username}")
            return fail(:invalid)
          end
        end

        if resource.new_record?
          if resource.errors[:base].any?
            info("Auth failed: not authorized for new user #{username}")
            fail!(:not_authorized)
          elsif validate(resource) { resource.valid_ldap_authentication?(password) }
            info("Auth valid but user #{username} not found in database")
            fail(:not_found_in_database)
          else
            info("Auth failed: invalid credentials for new user #{username}")
            fail(:invalid)
          end
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
    end
  end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)
