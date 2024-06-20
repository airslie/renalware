# frozen_string_literal: true

module Renalware
  module Events
    class InvestigationPolicy < EventPolicy
      def edit? = true
      alias update? edit?
    end
  end
end
