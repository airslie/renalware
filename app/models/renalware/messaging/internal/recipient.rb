module Renalware
  module Messaging
    module Internal
      class Recipient < Renalware::User
        # rubocop:disable Rails/RedundantForeignKey
        has_many :receipts, dependent: :destroy, foreign_key: :recipient_id
        # rubocop:enable Rails/RedundantForeignKey
        has_many :messages, through: :receipts

        def self.model_name = ActiveModel::Name.new(self, nil, "User")

        # Used when displaying the user in a select box, and includes a warning if the user
        # has never signed in or has not signed in for a long time.
        def option_text
          [to_s, activity_warning].compact_blank.join(" ")
        end

        def activity_warning
          if last_sign_in_at.nil?
            "(has never signed in)"
          elsif last_sign_in_at < num_days.days.ago
            "(inactive for #{last_active_days_ago} days)"
          end
        end

        def last_active_days_ago
          return if last_sign_in_at.blank?

          (Time.zone.now.to_date - last_sign_in_at.to_date).to_i
        end

        def num_days = Renalware.config.messaging_recipient_warn_if_not_signed_in_for_days
      end
    end
  end
end
