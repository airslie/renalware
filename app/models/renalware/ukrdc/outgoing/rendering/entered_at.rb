module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class EnteredAt < Rendering::Base
          pattr_initialize [:hospital_unit!]

          def xml
            element
          end

          private

          def element
            Ox::Element.new("EnteredAt").tap do |elem|
              elem << create_node("CodingStandard", "LOCAL")
              elem << create_node("Code", hospital_unit&.unit_code)
            end
          end
        end
      end
    end
  end
end
