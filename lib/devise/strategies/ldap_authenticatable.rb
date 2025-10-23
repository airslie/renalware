require "devise/strategies/authenticatable"

module Devise
  module Strategies
    # Custom LDAP authentication strategy for Renalware
    # Handles authorization errors and group-based access control
    class LdapAuthenticatable < Authenticatable
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
      def authenticate!
        return unless Renalware.config.ldap_authentication

        # This calls our own find_for_ldap_authentication method in
        # ldap_authenticatable concern.
        resource = mapping.to.find_for_ldap_authentication(
          authentication_hash.merge(password: password)
        )

        return fail(:invalid) unless resource

        if resource.persisted?
          if validate(resource) { resource.valid_ldap_authentication?(password) }
            unless resource.in_valid_ldap_group?
              return fail!(:not_authorized)
            end

            remember_me(resource)
            success!(resource)
          else
            return fail(:invalid)
          end
        end

        if resource.new_record?
          if resource.errors[:base].any?
            fail!(:not_authorized)
          elsif validate(resource) { resource.valid_ldap_authentication?(password) }
            fail(:not_found_in_database)
          else
            fail(:invalid)
          end
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
    end
  end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)
