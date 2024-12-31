module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class Address < Rendering::Base
          pattr_initialize [:address!]

          def xml
            address_element
          end

          private

          def address_element
            create_node("Address") do |elem|
              elem[:use] = "H"
              elem << create_node("Street", address.street)
              elem << create_node("Town", address.town)
              elem << create_node("County", address.county)
              elem << create_node("Postcode", address.postcode&.strip)
              elem << country_element if county_code?
            end
          end

          def country_element
            create_node("Country") do |elem|
              elem << create_node(:CodingStandard, "ISO3166-1")
              elem << create_node(:Code, address&.country&.alpha3)
              elem << create_node(:Description, address&.country&.to_s)
            end
          end

          def county_code?
            address&.country&.alpha3.present?
          end
        end
      end
    end
  end
end
