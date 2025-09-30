module Renalware
  module Users
    # Renders a section on the dashboard that displays the last date and time the
    # user signed in. This is a National Cyber Security Centre recommendation.
    class LastSigninComponent < ApplicationComponent
      include Renalware::UsersHelper
      include Renalware::TooltipHelper

      pattr_initialize [:current_user!]
      delegate :last_sign_in_at,
               :current_sign_in_at,
               :last_failed_sign_in_at,
               to: :current_user

      def sign_in_message
        if failed_sign_in_more_recent_than_last_sign_in?
          t(".failed_sign_in", datetime: datetime(last_failed_sign_in_at)).html_safe
        else
          t(".last_sign_in", datetime: datetime(effective_last_sign_in_at)).html_safe
        end
      end

      def render?
        effective_last_sign_in_at.present? || last_failed_sign_in_at.present?
      end

      private

      def datetime(at)
        tooltip(
          label: time_ago_in_words(at),
          content: "<span class='whitespace-nowrap'>#{l(at)}</span>"
        )
      end

      def background_class
        "bg-red-200 px-2" if failed_sign_in_more_recent_than_last_sign_in?
      end

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
