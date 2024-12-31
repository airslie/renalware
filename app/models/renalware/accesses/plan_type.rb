module Renalware
  module Accesses
    class PlanType < ApplicationRecord
      acts_as_paranoid

      validates :name, presence: true

      scope :ordered, -> { order(:position, :name) }

      def self.policy_class = BasePolicy
      def to_s = name
    end
  end
end
