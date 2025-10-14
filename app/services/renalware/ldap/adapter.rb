module Renalware
  module Ldap
    class Adapter
      delegate :valid_credentials?, to: :"::Devise::LDAP::Adapter"

      def get_ldap_param(username, attribute)
        ::Devise::LDAP::Adapter.get_ldap_param(username, attribute)&.first
      end

      def user_in_group?(username, group_dn)
        # "member" is the standard LDAP attribute for group membership
        ::Devise::LDAP::Adapter.in_ldap_group?(username, group_dn, "member")
      end

      def user_attributes(username, attributes)
        attributes.index_with { |attr| get_ldap_param(username, attr) }
      end

      def user_profile(username)
        user_attributes(username, %w(mail givenName cn sn)).tap do |attrs|
          attrs["givenName"] ||= attrs["cn"]
        end
      end
    end
  end
end
