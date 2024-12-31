module Renalware
  module System
    class NagDefinitionPolicy < BasePolicy
      def new?    = user_is_super_admin?
      def create? = new?
      def edit?   = new?
      def update? = create?
      def index?  = user_is_super_admin? || user_is_admin?
    end
  end
end
