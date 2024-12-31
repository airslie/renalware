module Renalware
  class UserPolicy < BasePolicy
    def update?
      super && !user_update_self?
    end

    def assign_role?(role)
      return false if role.hidden

      can_assign_role = case role.name
                        when "devops", "super_admin" then false
                        when "admin" then user_is_super_admin?
                        else true
                        end
      can_assign_role && update?
    end

    private

    def user_update_self?
      record == user
    end
  end
end
