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
      has_many :calculation_sources,
               dependent: :destroy,
               foreign_key: :calculated_observation_id
      has_many :calculated_observations, through: :calculation_sources
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
