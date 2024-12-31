module Renalware
  module Drugs::DMD
    module Repositories
      class ParseHelper
        # This can really dig stuff out :) See tests
        def self.dig_property_out(node, key, excluded_values: []) # rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
          property = node.find { |el|
            next if el["extension"].blank?

            next if excluded_values.include?(el["extension"][1]["valueCode"])

            el["extension"][0]["valueCode"] == key
          }

          if property
            value_property = property["extension"][1]
            return value_property["valueBoolean"] if value_property.key?("valueBoolean")

            return value_property["valueDecimal"] ||
                   value_property["valueCode"] ||
                   value_property["valueCoding"]["code"]
          end

          subproperty = node.find { |el|
            (el["extension"][0]["valueCode"] == "VPI") if el["extension"].present?
          }

          if subproperty && subproperty["extension"]
            dig_property_out(subproperty["extension"], key)
          end
        end
      end
    end
  end
end
