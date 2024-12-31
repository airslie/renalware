module Renalware
  module Accesses
    class NeedlingAssessmentPolicy < BasePolicy
      def destroy?
        return false unless record.persisted?
        return true if user_is_super_admin?

        author? && author_deletion_window_open?
      end

      def show?
        false
      end
      alias edit? show?
      alias update? show?
      alias index? show?

      private

      def author?
        record.created_by_id == user.id
      end

      def author_deletion_window_open?
        record.created_at > Renalware.config.new_clinic_visit_deletion_window.ago
      end
    end
  end
end
