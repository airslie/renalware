module Renalware
  module Admin
    class ConfigPolicy < BasePolicy
      def show?   = user_is_super_admin?
      def update? = false
      alias edit? update?
      alias create? update?
      alias destroy? update?
    end
  end
end
