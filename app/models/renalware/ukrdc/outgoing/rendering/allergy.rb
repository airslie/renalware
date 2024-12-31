module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class Allergy < Rendering::Base
          pattr_initialize [:allergy!]

          def xml
            allergy_element
          end

          private

          def allergy_element
            create_node("Allergy") do |elem|
              create_node("Allergy") # this is correct, see schema
              elem << Rendering::Clinician.new(user: allergy.updated_by).xml
              elem << create_node("FreeTextAllergy", allergy.description)
            end
          end
        end
      end
    end
  end
end
