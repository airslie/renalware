module Renalware
  module HD
    class OpenSessionPolicy < BasePolicy
      def destroy?            = edit?
      def edit?               = record.persisted?
      def copy_to_clipboard?  = false
    end
  end
end
