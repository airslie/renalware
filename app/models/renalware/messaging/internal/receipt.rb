module Renalware
  module Messaging
    module Internal
      class Receipt < ApplicationRecord
        validates :recipient, presence: true
        validates :message, presence: true

        belongs_to :message
        belongs_to :recipient, touch: true, class_name: "Recipient"

        scope :unread, -> { where(read_at: nil) }
        scope :read, -> { where.not(read_at: nil) }
        scope :ordered, -> { joins(:message).merge(Message.ordered) }
        scope :sent_by, lambda { |user_id|
          joins(:message).where(messaging_messages: { author_id: user_id })
        }

        def read?
          read_at.present?
        end
      end
    end
  end
end
