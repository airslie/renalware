module Renalware
  module Transplants
    class RejectionEpisodePolicy < BasePolicy
      def destroy?
        return true unless record.persisted?
        return true if user_is_devops? || user_is_super_admin?

        false
      end
    end
  end
end
