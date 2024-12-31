module Renalware
  module System
    class Message < ApplicationRecord
      extend Enumerize
      validates :body, presence: true
      validates :display_from, timeliness: { type: :datetime }, presence: true
      validates :display_until,
                timeliness: { type: :datetime, allow_blank: true, after: :display_from }
      enumerize :severity, in: %i(default warning info success)

      scope :active, lambda {
        where(
          "display_from <= ? and (display_until is null or display_until >= ?)",
          Time.zone.now,
          Time.zone.now
        )
      }

      # Return true if the message should be visible.
      # A message is visible if display_from is in the past and display_until is nil
      # or in the future
      def active?
        return false if display_from.nil?

        now = Time.zone.now
        self.display_until ||= far_future_date
        return true if display_from < now && display_until > now

        false
      end

      private

      def far_future_date
        Time.zone.parse("2999-01-01 00:00:01")
      end
    end
  end
end
