require "fileutils"

module Renalware
  # This job is used to expire users who have not been active for a certain number of days.
  # The number of days is set in the devise_security initializer.
  # Although we do not need to set expired_at, and could rely on last_activity_at being older than ]
  # the expiry period, we set expired_at to make it easier to query for expired users and to help
  # to display them under the Users -> Expired tab.
  class ExpireInactiveUsersJob < ApplicationJob
    queue_with_priority 10 # low

    def perform
      sql = <<-SQL.squish
        UPDATE renalware.users set expired_at = NOW()
        WHERE last_activity_at <
          (NOW() - INTERVAL '#{days_after_which_an_inactive_user_should_be_expired} days')
        AND expired_at IS NULL
      SQL
      User.connection.execute(sql)
    end

    def days_after_which_an_inactive_user_should_be_expired = Renalware.config.users_expire_after
  end
end
