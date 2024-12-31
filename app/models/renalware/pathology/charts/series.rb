module Renalware
  module Pathology
    module Charts
      # A series of data belonging to a chart, pre-defined in data
      class Series < ApplicationRecord
        self.table_name = :pathology_chart_series
        belongs_to :chart
        belongs_to :observation_description, class_name: "Pathology::ObservationDescription"
        validates :chart, presence: true
        validates :observation_description, presence: true
        delegate :code, :chart_colour, :axis_type, to: :observation_description
      end
    end
  end
end
