module Renalware
  module System
    class ViewMetadataPolicy < BasePolicy
      def edit?     = user_is_super_admin?
      def restore?  = edit?

      alias chart? show?
      alias chart_raw? show?
      alias content? show?
    end
  end
end
