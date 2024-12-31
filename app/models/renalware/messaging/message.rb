#
# Abstract Message base class.
# Use Internal::Message etc. subclasses (stored via STI).
#
module Renalware
  module Messaging
    class Message < ApplicationRecord
      validates :body, presence: true
      validates :subject, presence: true
      validates :author, presence: true
      validates :patient, presence: true
      validates :sent_at, presence: true

      belongs_to :patient # no touch required
      belongs_to :author, class_name: "Renalware::User"
    end
  end
end
