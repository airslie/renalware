# Represents an Electronic CC - a reference to a letter sent to a recipient (another user on the
# system) as a 'CC'. We use the concept of a 'receipt' which, while mainly being a cross table
# between letter and recipient user, is also a well-named place to store related information
# for example whether the message has been read (e.g. the letter viewed).
module Renalware
  module Letters
    class ElectronicReceipt < ApplicationRecord
      belongs_to :letter, touch: true
      belongs_to :recipient, class_name: "Renalware::User"
      validates :letter, presence: true
      validates :recipient_id, presence: true

      # Merge scope here to make sure we only get approved letters
      scope :sent_by, lambda { |user_id|
        joins(:letter)
          .merge(Letter::Approved.all)
          .where(letter_letters: { author_id: user_id })
      }
      scope :unread, lambda {
        where(read_at: nil)
          .joins(:letter)
          .merge(Letter.approved_or_completed)
      }
      scope :read, lambda {
        where.not(read_at: nil)
          .joins(:letter)
          .merge(Letter.approved_or_completed)
      }
      scope :for_recipient, ->(user_id) { where(recipient_id: user_id) }
      scope :ordered, -> { order(created_at: :desc) }

      def read?
        read_at.present?
      end

      def unread?
        !read?
      end
    end
  end
end
