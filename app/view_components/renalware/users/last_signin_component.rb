module Renalware
  module Users
    # Renders a section on the dashboard that displays the last date and time the
    # user signed in. This is a National Cyber Security Centre recommendation.
    class LastSigninComponent < ApplicationComponent
      include Renalware::UsersHelper

      pattr_initialize [:current_user!]
      delegate :last_sign_in_at,
               :current_sign_in_at,
               :last_failed_sign_in_at,
               to: :current_user

      def sign_in_message
        key, at =
          if failed_sign_in_more_recent_than_last_sign_in?
            [".failed_sign_in", last_failed_sign_in_at]
          else
            [".last_sign_in", effective_last_sign_in_at]
          end

        t(key, time: at.strftime("%H:%M"), date: at.strftime("%d-%b-%Y"))
      end

      def render?
        effective_last_sign_in_at.present? || last_failed_sign_in_at.present?
      end

      private

      def failed_sign_in_more_recent_than_last_sign_in?
        return false if last_failed_sign_in_at.nil?
        return true if last_sign_in_at == current_sign_in_at
        return true if last_sign_in_at.nil?

        last_failed_sign_in_at > last_sign_in_at
      end

      def effective_last_sign_in_at
        last_sign_in_at unless last_sign_in_at == current_sign_in_at
      end
    end
  end
end
