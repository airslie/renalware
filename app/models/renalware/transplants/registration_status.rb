module Renalware
  module Transplants
    class RegistrationStatus < ApplicationRecord
      include Accountable

      belongs_to :description, class_name: "RegistrationStatusDescription"
      belongs_to :registration, touch: true

      scope :ordered, -> { order(started_on: :asc, created_at: :asc) }
      scope :reversed, -> { order(started_on: :desc, created_at: :desc) }

      validates :description_id, presence: true
      validates :started_on, presence: true, timeliness: { type: :date, allow_blank: false }
      validates :terminated_on, timeliness: { type: :date, allow_blank: true }

      validate :constraint_started_on_today_or_before, if: :started_on

      def self.policy_class = BasePolicy

      def terminated?
        terminated_on.present?
      end

      def constraint_started_on_today_or_before
        errors.add(:started_on, :invalid) if started_on > Time.zone.today
      end

      def to_s
        description&.to_s
      end
    end
  end
end
