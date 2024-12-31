module Renalware
  module Pathology
    module Charts
      # A chart pre-defined in data
      class Chart < ApplicationRecord
        self.table_name = :pathology_charts
        has_many :series, dependent: :destroy
        has_many(:observation_descriptions, through: :series)

        scope :enabled, -> { where(enabled: true) }

        default_scope -> { enabled }
        validates :title, presence: true
        delegate :axis_label, :axis_type, to: :first_observation_description, allow_nil: true

        def chart_series_json(patient_id:, start_date:)
          series.map do |series|
            series.observation_description.chart_series_json(
              patient_id: patient_id,
              start_date: start_date
            )
          end
        end

        private

        def first_series
          series.first
        end

        def first_observation_description
          first_series&.observation_description
        end
      end
    end
  end
end
