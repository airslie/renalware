module Renalware
  module Problems
    class Note < ApplicationRecord
      include Accountable
      acts_as_paranoid
      alias archived? deleted?

      belongs_to :problem, touch: true

      scope :ordered, -> { order(created_at: :asc) }
      scope :archived, -> { only_deleted }
      scope :with_archived, -> { with_deleted }

      validates :description, presence: true

      def self.policy_class = BasePolicy
    end
  end
end
