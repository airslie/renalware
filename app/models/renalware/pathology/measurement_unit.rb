module Renalware
  module Pathology
    class MeasurementUnit < ApplicationRecord
      validates :name, presence: true
      has_many :observation_descriptions, inverse_of: :measurement_unit
      belongs_to :ukrdc_measurement_unit,
                 class_name: "Renalware::UKRDC::MeasurementUnit",
                 optional: true

      def self.for_collection_select
        order(:name).select(:id, :name, :description).map { |row| [row.title, row.id] }
      end

      # A friendly string containing name and description (if present) in parentheses
      # e.g. "l (litres)"
      def title
        return name if description.blank? || name == description

        "#{name} (#{description})"
      end
    end
  end
end
