module Renalware
  module Accesses
    class Plan < ApplicationRecord
      include Accountable

      belongs_to :patient, touch: true
      belongs_to :plan_type
      belongs_to :decided_by, class_name: "User"

      validates :plan_type, presence: true
      validates :decided_by, presence: true

      scope :ordered, -> { order(created_at: :desc) }
      scope :current, -> { where(terminated_at: nil) }
      scope :historical, -> { where.not(terminated_at: nil) }

      def self.policy_class = BasePolicy

      def self.attributes_to_ignore_when_comparing
        %i(id created_at updated_at created_by_id updated_by_id)
      end

      def identical_to?(other)
        attrs_to_ignore = self.class.attributes_to_ignore_when_comparing.map(&:to_s)
        attributes.except(*attrs_to_ignore) == other.attributes.except(*attrs_to_ignore)
      end

      def terminate_by(user)
        self.terminated_at = Time.zone.now
        self.by = user
        save!
      end
    end
  end
end
