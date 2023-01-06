# frozen_string_literal: true

module Renalware
  module Pathology
    class Observation < ApplicationRecord
      belongs_to :request,
                 class_name: "ObservationRequest",
                 touch: true,
                 inverse_of: :observations
      belongs_to :description,
                 class_name: "ObservationDescription",
                 inverse_of: :observations
      # ,counter_cache: true,
      # touch: :last_observed_at

      validates :description, presence: true
      # validates :result, presence: true, unless: ->(obs) { obs.cancelled? }
      validates :observed_at, presence: true

      scope :ordered, -> { order(observed_at: :desc) }
      scope :for_description, ->(description) { where(description: description) }
      scope :having_a_loinc_code, -> { joins(:description).where.not(loinc_code: nil) }

      def observed_on
        observed_at.to_date
      end

      delegate :to_s, to: :result
    end
  end
end
