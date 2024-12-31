module Renalware
  module Research
    class ParticipationPolicy < ResearchPolicy
      def create?
        return false if record.study.blank?

        user_is_super_admin? || user_is_an_investigator_in_this_study?
      end
      alias edit? create?
      alias new? create?

      def destroy?
        return false if record.study.blank?

        user_is_super_admin? || user_is_a_manager_in_this_study?
      end
    end
  end
end
