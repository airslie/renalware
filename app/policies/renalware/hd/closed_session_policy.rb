module Renalware
  module HD
    class ClosedSessionPolicy < BasePolicy
      def destroy? = edit?

      def edit?
        return false unless record.persisted?

        user_is_admin? || user_is_super_admin? || !record.immutable?
      end
    end
  end
end
