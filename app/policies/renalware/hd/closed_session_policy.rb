# frozen_string_literal: true

module Renalware
  module HD
    class ClosedSessionPolicy < BasePolicy
      def destroy?
        edit?
      end

      def edit?
        return false unless record.persisted?

        user_is_super_admin? || !record.immutable?
      end
    end
  end
end
