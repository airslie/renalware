module Renalware
  module Clinics
    class MappingPolicy < BasePolicy
      def index? = user_is_super_admin?
      alias new? index?
      alias create? index?
      alias edit? index?
      alias update? index?
      alias destroy? index?
      alias show? index?
    end
  end
end
