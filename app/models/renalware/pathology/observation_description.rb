# frozen_string_literal: true

module Renalware
  module Pathology
    class ObservationDescription < ApplicationRecord
      include RansackAll
      include Charts::Chartable

      belongs_to :measurement_unit
      belongs_to :suggested_measurement_unit, class_name: "MeasurementUnit"
      belongs_to :created_by_sender, class_name: "Sender"
      has_many :observations,
               class_name: "Pathology::Observation",
               inverse_of: :description,
               dependent: :restrict_with_exception
      has_many :code_group_memberships, dependent: :destroy
      has_many :code_groups, through: :code_group_memberships
      has_many :obx_mappings, dependent: :destroy

      enum :rr_type, { rr_type_simple: 0, rr_type_interpretation: 1 }
      enum :rr_coding_standard, { ukrr: 0, pv: 1 }

      validates :lower_threshold, numericality: { allow_nil: true }
      validates :upper_threshold, numericality: { allow_nil: true }
      validate :lower_threshold_lteq_upper_threshold

      def self.for(codes)
        ObservationDescriptionsByCodeQuery.new(codes: codes).call
      end

      def self.policy_class = BasePolicy

      def to_s
        code
      end

      private

      def lower_threshold_lteq_upper_threshold
        return if lower_threshold.blank?
        return if upper_threshold.blank?

        if lower_threshold.to_f >= upper_threshold.to_f
          errors.add(:lower_threshold, "must be less than the upper threshold")
        end
      end
    end
  end
end
