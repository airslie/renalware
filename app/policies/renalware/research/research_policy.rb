# frozen_string_literal: true

require_dependency "renalware/research"

module Renalware
  module Research
    class ResearchPolicy < BasePolicy
      def create?
        user_is_admin? || user_is_super_admin?
      end
      alias_method :edit?, :create?
      alias_method :new?, :create?
      alias_method :destroy?, :create?
    end
  end
end
