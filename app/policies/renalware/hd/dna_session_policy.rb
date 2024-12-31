module Renalware
  module HD
    class DNASessionPolicy < BasePolicy
      def destroy? = edit?

      def edit?
        return false unless record.persisted?

        user_is_super_admin? || !record.immutable?
      end
    end
  end
end
