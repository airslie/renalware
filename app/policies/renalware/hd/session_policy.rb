module Renalware
  module HD
    # More liberal access is provided in the STI-specific policy e.g. ClosedSessionPolicy
    # This policy exists mainly for index? because when all sessions are loaded (e.g. in an #all
    # query) Session is their common ancestor.
    class SessionPolicy < BasePolicy
      def destroy?  = false
      def edit?     = false
      def update?   = false
      def create?   = false
    end
  end
end
