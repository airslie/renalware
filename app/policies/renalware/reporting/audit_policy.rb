# frozen_string_literal: true

module Renalware
  module Reporting
    class AuditPolicy < BasePolicy
      def refresh?
        user_is_super_admin?
      end

      def edit?
        user_is_super_admin?
      end

      def update?
        user_is_super_admin?
      end
    end
  end
end
