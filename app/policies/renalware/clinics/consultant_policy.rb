module Renalware
  module Clinics
    class ConsultantPolicy < BasePolicy
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
        return false if record.deleted?

        user_is_super_admin?
      end
      alias destroy? edit?
      alias update? edit?
    end
  end
end
