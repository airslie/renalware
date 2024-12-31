module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class Name < Rendering::Base
          pattr_initialize [:nameable!]

          def xml
            element
          end

          private

          def element
            Ox::Element.new("Name").tap do |elem|
              elem[:use] = "L"
              elem << create_node("Prefix", nameable.title)
              elem << create_node("Family", nameable.family_name.strip)
              elem << create_node("Given", nameable.given_name.strip)
              elem << create_node("Suffix", nameable.suffix)
            end
          end
        end
      end
    end
  end
end
