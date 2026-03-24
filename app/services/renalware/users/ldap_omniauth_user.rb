module Renalware
  module Users
    class LdapOmniauthUser
      class NotAuthorisedError < StandardError; end

      def initialize(auth:, password:)
        @auth = auth
        @password = password
      end

      def call
        user = User.find_by(username:) || build_user_from_fallback_identity
        User.sync_roles(user, member_of_groups)
        unless authorised?(user)
          raise NotAuthorisedError, "User is not in an authorised Active Directory group"
        end

        user.save! if user.changed?
        user
      end

      private

      attr_reader :auth, :password

      def build_user_from_fallback_identity
        (email.present? ? User.find_or_initialize_by(email:) : User.new).tap do |user|
          populate_new_ldap_user(user)
        end
      end

      def populate_new_ldap_user(user)
        user.username ||= username
        user.email ||= email
        user.family_name ||= info.last_name
        user.given_name ||= info.first_name
        user.password ||= password.presence || SecureRandom.hex(32)
        user.approved = Renalware.config.ldap_auto_approve_users
        user.hospital_centre = Renalware::Hospitals::Centre.site_default
      end

      def username
        auth.uid
      end

      def info
        auth.info
      end

      def email
        info.email&.downcase
      end

      def member_of_groups
        ldap_managed_groups.presence || auth.extra.raw_info["memberof"]
      end

      def ldap_managed_groups
        @ldap_managed_groups ||= Ldap::Connection.new(username:).nested_group_names(
          group_names: managed_ad_role_names
        )
      end

      def managed_ad_role_names
        @managed_ad_role_names ||= Role.where.not(ad_role_name: nil).pluck(:ad_role_name)
      end

      def authorised?(user)
        user.roles.any? { |role| role.ad_role_name.present? }
      end
    end
  end
end
