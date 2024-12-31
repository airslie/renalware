module Renalware
  module Clinics
    class ClinicVisitPolicy < BasePolicy
      def destroy?
        return false unless record.persisted?

        record.created_at > Renalware.config.new_clinic_visit_deletion_window.ago &&
          (user_created_record? || user_is_super_admin?)
      end

      def edit?
        return false unless record.persisted?

        record.created_at > Renalware.config.new_clinic_visit_edit_window.ago &&
          (user_created_record? || user_is_super_admin?)
      end

      private

      def user_created_record?
        record.created_by_id == user.id
      end
    end
  end
end
