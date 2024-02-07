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

      alias :chart? :show?
      alias :chart_raw? :show?
      alias :content? :show?
    end
  end
end
