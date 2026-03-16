require "devise/strategies/database_authenticatable"

module Devise
  module Strategies
    # This strategy overrides the default :database_authenticatable strategy
    # to only authenticate when database authentication is enabled.
    class RenalwareDatabaseAuthenticatable < DatabaseAuthenticatable
      def authenticate!
        return unless Renalware.config.database_authentication_enabled?

        if valid_for_database_authentication?
          remember_me(resource)
          resource.after_database_authentication
          success!(resource)
          return
        end

        fail_authentication
      end

      private

      def resource
        @resource ||= password.present? && begin
          mapping.to.find_for_database_authentication(authentication_hash)
        end
      end

      def valid_for_database_authentication?
        validate(resource) { resource.database_valid_password?(password) }
      end

      def fail_authentication
        mapping.to.new.password = password if resource.blank? && Devise.paranoid
        return fail(:invalid) if resource.present? || Devise.paranoid

        fail(:not_found_in_database)
      end
    end
  end
end

Warden::Strategies.add(:database_authenticatable, Devise::Strategies::RenalwareDatabaseAuthenticatable)
