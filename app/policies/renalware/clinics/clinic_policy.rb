module Renalware
  module Clinics
    class ClinicPolicy < BasePolicy
      def index? = user_is_any_admin?
      alias show? index?

      def new? = user_is_super_admin?
      alias create? new?

      def edit?
        return false unless record.persisted?
        return false if record.deleted?

        user_is_super_admin?
      end
      alias update? edit?
      alias destroy? edit?
    end
  end
end
