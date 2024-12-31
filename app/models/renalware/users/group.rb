module Renalware
  module Users
    class Group < ApplicationRecord
      include Accountable
      validates :name, presence: true, uniqueness: true

      has_many(
        :memberships,
        class_name: "Groups::Membership",
        dependent: :destroy,
        foreign_key: :user_group_id,
        inverse_of: :group
      )
      has_many(
        :users,
        through: :memberships
      )

      scope :ordered, -> { order(name: :asc) }

      def self.policy_class = BasePolicy
    end
  end
end
