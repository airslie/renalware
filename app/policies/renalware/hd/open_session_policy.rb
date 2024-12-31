module Renalware
  module HD
    class OpenSessionPolicy < BasePolicy
      def destroy?  = edit?
      def edit?     = record.persisted?
    end
  end
end
