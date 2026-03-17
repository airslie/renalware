module Renalware
  module UKRDC
    # Represents a valid UKRDC pathology test result measurement unit e.g. "mg".
    # See https://github.com/renalreg/ukrdc/blob/master/Schema/Types/CF_RR23.xsd
    class MeasurementUnit < ApplicationRecord
      validates :name, presence: true

      # Map our dm+d unit of measure to an equivalent one if there is one.
      # Given a dmd uom like 'litre', try to match against UKRDC UOM attributes
      # - name eg L => no match
      # - description eg "litres" => no match
      # - alias array eg ["litre"] => match
      def self.for_dmd_name(name)
        where(name:)
          .or(where(description: name)
            .or(where("? = ANY(alias)", name))).first
      end

      # A friendly string containing the name followed by the description (if present)
      # in parentheses e.g. "l (litres)"
      def title
        return name if description.blank? || name == description

        "#{name} (#{description})"
      end
    end
  end
end
