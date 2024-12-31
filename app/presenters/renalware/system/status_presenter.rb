module Renalware
  module System
    class StatusPresenter
      def last_user_login_at = User.maximum(:current_sign_in_at)
      def last_activity_at = User.maximum(:last_activity_at)
      def active_users(in_last: 30.minutes) = User.where(last_activity_at: in_last.ago..).count
    end
  end
end
