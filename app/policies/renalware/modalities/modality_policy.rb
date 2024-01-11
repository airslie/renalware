# frozen_string_literal: true

module Renalware
  module Modalities
    class ModalityPolicy < BasePolicy
      def edit? = user_is_at_least_super_admin?
      def update? = user_is_at_least_super_admin?
      def destroy? = user_is_at_least_super_admin?
    end
  end
end
