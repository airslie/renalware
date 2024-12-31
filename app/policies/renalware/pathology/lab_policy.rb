module Renalware
  module Pathology
    class LabPolicy < BasePolicy
      def index?
        user_is_any_admin?
      end
      alias show? index?

      def new?
        user_is_super_admin?
      end
      alias create? new?

      def edit?
        return false unless record.persisted?

        user_is_super_admin?
      end
      alias update? edit?
      alias destroy? edit?
    end
  end
end
