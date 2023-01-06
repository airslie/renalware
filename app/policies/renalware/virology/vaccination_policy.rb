# frozen_string_literal: true

module Renalware
  module Virology
    class VaccinationPolicy < Events::EventPolicy
      def edit?
        user_is_super_admin?
      end
      alias update? edit?
      alias destroy? edit?
    end
  end
end
