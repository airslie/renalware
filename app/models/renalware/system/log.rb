module Renalware
  module System
    class Log < ApplicationRecord
      include RansackAll

      validates :severity, presence: true
      validates :group, presence: true
      enum :severity, {
        info: "info",
        warning: "warning",
        error: "error"
      }
      enum :group, {
        users: "users",
        admin: "admin",
        superadmin: "superadmin",
        developer: "developer"
      }

      severities.each_key do |severity|
        define_singleton_method(severity.to_sym) do |message, group: :admin|
          create!(
            message: message,
            group: group,
            severity: severity.to_sym
          )
        end
      end
    end
  end
end
