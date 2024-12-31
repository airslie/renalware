module Renalware
  module System
    class UsersAwaitingApprovalComponent < ApplicationComponent
      rattr_initialize [:current_user!]

      def users_needing_approval_count
        @users_needing_approval_count ||= User.unapproved.count
      end
    end
  end
end
