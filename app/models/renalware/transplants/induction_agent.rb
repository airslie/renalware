module Renalware
  module Transplants
    class InductionAgent < ApplicationRecord
      scope :ordered, -> { order(position: :asc, name: :asc) }
      has_many :recipient_operations, dependent: :restrict_with_exception

      validates :name, presence: true, uniqueness: { case_sensitive: false }

      def to_s = name
    end
  end
end
