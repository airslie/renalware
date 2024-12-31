module Renalware
  module Pathology
    class CodeGroupPolicy < BasePolicy
      def create?   = user_is_super_admin?
      def update?   = create?
      def destroy?  = create?
      def edit?     = create?
    end
  end
end
