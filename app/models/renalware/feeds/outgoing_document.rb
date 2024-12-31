module Renalware
  module Feeds
    class OutgoingDocument < ApplicationRecord
      include Accountable
      include RansackAll

      belongs_to :renderable, polymorphic: true
      validates :state, presence: true
      enum :state, {
        queued: "queued",
        errored: "errored",
        processed: "processed"
      }

      scope :queued_for_processing, -> { queued.order(created_at: :asc) }
      scope :ordered, -> { order(created_at: :desc) }

      def self.policy_class = BasePolicy
    end
  end
end
