module Renalware
  module AdminHelper
    def admin_unapproved_users_path
      admin_users_path(q: { unapproved: true })
    end

    def admin_inactive_users_path
      admin_users_path(q: { inactive: true })
    end

    def admin_expired_users_path
      admin_users_path(q: { expired: true })
    end
  end
end
