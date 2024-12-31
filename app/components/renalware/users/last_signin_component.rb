module Renalware
  module Users
    # Renders a section on the dashboard that displays the last date and time the
    # user signed in. This is a National Cyber Security Centre recommendation.
    class LastSigninComponent < ApplicationComponent
      include Renalware::UsersHelper
      pattr_initialize [:current_user!]
      delegate :last_sign_in_at, :current_sign_in_at, to: :current_user

      def effective_last_sign_in_at
        return if last_sign_in_at.blank? || last_sign_in_at == current_sign_in_at

        last_sign_in_at
      end

      def render?
        effective_last_sign_in_at.present?
      end
    end
  end
end
