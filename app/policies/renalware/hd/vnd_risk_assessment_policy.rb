module Renalware
  module HD
    class VNDRiskAssessmentPolicy < BasePolicy
      alias_attribute :assessment, :record

      def destroy? = assessment.persisted? && author?

      # Decided not to allow editing.
      # To re-enable for author and superadmin use
      #   assessment.persisted? && (user_is_super_admin? || author?)
      def edit? = false

      private

      def author? = assessment.created_by == user
    end
  end
end
