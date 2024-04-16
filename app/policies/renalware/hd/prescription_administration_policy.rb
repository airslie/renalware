# frozen_string_literal: true

module Renalware
  module HD
    class PrescriptionAdministrationPolicy < BasePolicy
      def destroy?
        user_is_any_admin?
      end
    end
  end
end
