module Renalware
  module Letters
    class TopicPolicy < BasePolicy
      def index? = user_is_any_admin?
      alias show? index?

      def new? = user_is_super_admin?
      alias create? new?
      alias sort? new?

      def edit?
        return false if record.deleted?

        user_is_super_admin?
      end
      alias update? edit?
      alias destroy? edit?
    end
  end
end
