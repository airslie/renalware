# frozen_string_literal: true

module Renalware
  module Modalities
    class Modality < ApplicationRecord
      include Accountable
      include PatientScope

      belongs_to :description, class_name: "Description"
      belongs_to :patient, touch: true
      belongs_to :reason, class_name: "Reason"

      scope :ordered, -> { order(ended_on: :desc, updated_at: :desc) }
      scope :started_on_reversed, -> { order(started_on: :desc, updated_at: :desc) }
      scope :last_started_on, -> { started_on_reversed.where(ended_on: nil) }

      validates :patient, presence: true
      validates :started_on, presence: true
      validates :description, presence: true
      validates :started_on, timeliness: { type: :date, on_or_before: -> { Date.current } }
      validate :validate_modality_starts_later_than_previous, on: :create, if: :patient

      def terminate_by(user, on:)
        self.ended_on = on
        self.state = "terminated"
        save_by!(user)
      end

      def to_s
        description.name
      end

      def terminated?
        state == "terminated"
      end

      def self.policy_class
        BasePolicy
      end

      private

      def validate_modality_starts_later_than_previous
        unless started_later_than_previous?
          errors.add(:started_on, "can't be before previous modality's start date.")
        end
      end

      def started_later_than_previous?
        if (previous_modality = patient.modalities.last_started_on.first)
          started_on.present? && started_on >= previous_modality.started_on
        else
          true
        end
      end

      def terminate!(successor)
        self.ended_on = successor.started_on
        self.state = "terminated"
        self.by = successor.by
        save!
      end
    end
  end
end
