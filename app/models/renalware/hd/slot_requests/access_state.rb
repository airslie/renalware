module Renalware
  module HD
    module SlotRequests
      class AccessState < ApplicationRecord
        validates :name, presence: true, uniqueness: true
        has_many :slot_requests, dependent: :restrict_with_exception
        scope :ordered, -> { order(position: :asc, name: :asc) }
      end
    end
  end
end
