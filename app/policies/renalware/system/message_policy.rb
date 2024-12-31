module Renalware
  module System
    class MessagePolicy < BasePolicy
      def new?      = user_is_super_admin?
      def create?   = user_is_super_admin?
      def destroy?  = user_is_super_admin?
    end
  end
end
