module Renalware
  module HD
    class DNASessionPolicy < BasePolicy
      def destroy? = edit?

      def edit?
        return false unless record.persisted?

        user_is_super_admin? || !record.immutable?
      end

      def copy_to_clipboard? = false
    end
  end
end
