# frozen_string_literal: true

module Renalware
  module Admin
    class CachePolicy < BasePolicy
      def show?
        user_is_super_admin?
      end

      def destroy
        user_is_super_admin?
      end
    end
  end
end
