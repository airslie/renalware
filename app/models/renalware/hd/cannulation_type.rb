module Renalware
  module HD
    class CannulationType < ApplicationRecord
      acts_as_paranoid

      validates :name, presence: true

      scope :ordered, -> { order(:name) }

      def self.policy_class = BasePolicy

      def to_s = name
    end
  end
end
