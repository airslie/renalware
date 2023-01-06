# frozen_string_literal: true

module Renalware
  module System
    class MessagePolicy < BasePolicy
      def new?
        user_is_super_admin?
      end

      def create?
        user_is_super_admin?
      end

      def destroy?
        user_is_super_admin?
      end
    end
  end
end
