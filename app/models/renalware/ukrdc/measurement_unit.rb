module Renalware
  module UKRDC
    # Represents a valid UKRDC pathology test result measurement unit e.g. "mg".
    # See https://github.com/renalreg/ukrdc/blob/master/Schema/Types/CF_RR23.xsd
    class MeasurementUnit < ApplicationRecord
      validates :name, presence: true

      # A friendly string containing the name followed by the description (if present)
      # in parentheses e.g. "l (litres)"
      def title
        return name if description.blank? || name == description

        "#{name} (#{description})"
      end
    end
  end
end
