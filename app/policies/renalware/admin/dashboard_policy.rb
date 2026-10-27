module Renalware
  module Admin
    class DashboardPolicy < BasePolicy
      def show? = user_is_any_admin?
    end
  end
end
