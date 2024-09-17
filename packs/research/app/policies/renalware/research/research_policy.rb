# frozen_string_literal: true

module Renalware
  module Research
    class ResearchPolicy < BasePolicy
      def create?
        user_is_admin? || user_is_super_admin?
      end
      alias edit? create?
      alias new? create?
      alias destroy? create?

      protected

      def user_is_an_investigator_in_this_study?
        investigator_ids.pluck(:user_id).include?(user.id)
      end

      def user_is_a_manager_in_this_study?
        investigator_ids.where(manager: true).pluck(:user_id).include?(user.id)
      end

      def investigator_ids
        study.investigatorships
      end

      def study
        record.study
      end
    end
  end
end
