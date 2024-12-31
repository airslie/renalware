module Renalware
  module System
    class UsersPresenter
      def list_for_dropdown(user_to_promote_to_top: nil)
        return users if user_to_promote_to_top.blank?

        matching_user = users.detect { |user| user.id == user_to_promote_to_top.id }
        make_user_first_in_list(matching_user) if matching_user.present?
        users
      end

      private

      def make_user_first_in_list(user)
        users.delete(user)
        users.unshift(user)
      end

      def users
        @users ||= Renalware::User.visible.select(:id, :family_name, :given_name).ordered.to_a
      end
    end
  end
end
