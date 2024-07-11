# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        module V4
          class PatientNumber < Rendering::Base
            pattr_initialize [:number!, :organisation!, :type!]

            def xml
              name_element
            end

            private

            def name_element
              create_node("PatientNumber") do |elem|
                elem << create_node("Number", number&.delete(" "))
                elem << create_node("Organization", organisation)
                elem << create_node("NumberType", type)
              end
            end
          end
        end
      end
    end
  end
end
