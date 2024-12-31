module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class User < Rendering::Base
          pattr_initialize [:user!]

          def xml
            user_element
          end

          private

          def user_element
            Ox::Element.new(element_name).tap do |elem|
              elem << create_node("CodingStandard", "LOCAL")
              elem << create_node("Code", user&.username)
              elem << create_node("Description", user&.to_s)
            end
          end

          # If a superclass called Clinician inherits from this class then the name of
          # element output will be <Clinician>
          def element_name
            self.class.name.demodulize
          end
        end
      end
    end
  end
end
