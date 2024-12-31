require "active_support/concern"

module Renalware
  module Concerns::DeviseControllerMethods
    extend ActiveSupport::Concern

    included do
      class_eval do
        before_action :authenticate_user!
        before_action :configure_permitted_parameters, if: :devise_controller?
      end

      protected

      def configure_permitted_parameters
        configure_sign_up_parameters
        configure_sign_in_parameters
        configure_account_update_parameters
      end

      def configure_sign_up_parameters
        devise_parameter_sanitizer.permit(
          :sign_up,
          keys: %i(
            given_name
            family_name
            username
            email
            password
            password_confirmation
            asked_for_write_access
            remember_me
            professional_position
            signature
            gmc_code
          )
        )
      end

      def configure_sign_in_parameters
        devise_parameter_sanitizer.permit(:sign_in, keys: %i(username password remember_me))
      end

      def configure_account_update_parameters
        devise_parameter_sanitizer.permit(
          :account_update,
          keys: %i(
            given_name
            family_name
            username
            email
            password
            password_confirmation
            current_password
            professional_position
            language
            signature
            gmc_code
            with_extended_validation
          )
        )
      end
    end
  end
end
