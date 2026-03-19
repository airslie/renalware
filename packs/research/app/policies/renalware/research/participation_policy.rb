module Renalware
  module Research
    class ParticipationPolicy < ResearchPolicy
      def create?
        return false if record.study.blank?
        return true if anyone_can_manage_participations?

        user_is_super_admin? || user_is_an_investigator_in_this_study?
      end
      alias edit? create?
      alias new? create?

      def destroy?
        return false if record.study.blank?
        return true if anyone_can_manage_participations?

        user_is_super_admin? || user_is_a_manager_in_this_study?
      end

      private

      def anyone_can_manage_participations?
        Renalware.config.research_anyone_can_manage_participations
      end
    end
  end
end
