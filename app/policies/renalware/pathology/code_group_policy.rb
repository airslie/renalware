module Renalware
  module Pathology
    class CodeGroupPolicy < BasePolicy
      def index?    = user_is_super_admin?
      def show?     = user_is_super_admin?
      def create?   = user_is_super_admin?
      def new?      = create?
      def update?   = create?
      def edit?     = create?
      def destroy?  = create?
      def draft?    = create?
      def preview?  = create?
    end
  end
end
