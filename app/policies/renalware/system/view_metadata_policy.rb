# frozen_string_literal: true

module Renalware
  module System
    class ViewMetadataPolicy < BasePolicy
      def edit?
        user_is_super_admin?
      end

      def restore?
        edit?
      end
    end
  end
end
