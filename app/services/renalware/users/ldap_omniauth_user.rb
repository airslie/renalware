module Renalware
  module Users
    class LdapOmniauthUser
      def initialize(auth:, password:)
        @auth = auth
        @password = password
      end

      def call
        user = User.find_by(username:) || build_user_from_fallback_identity
        User.sync_roles(user, member_of_groups)
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
        auth.extra.raw_info["memberof"]
      end
    end
  end
end
