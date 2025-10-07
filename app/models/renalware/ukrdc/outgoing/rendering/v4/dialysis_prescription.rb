# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        module V4
          class DialysisPrescription < Rendering::Base
            pattr_initialize [:hd_prescription!]

            def xml
              dialysis_prescription_element
            end

            private

            def dialysis_prescription_element
              create_node("DialysisPrescription") do |elem|
                elem << entered_on_element
                elem << from_time_element
                elem << to_time_element
                elem << session_type_element
                elem << sessions_per_week_element
                elem << time_dialysed_element
                elem << vascular_access_element
              end
            end

            def entered_on_element = create_node("EnteredOn")
            def from_time_element = create_node("FromTime")
            def to_time_element = create_node("ToTime")
            def session_type_element = create_node("SessionType")
            def sessions_per_week_element = create_node("SessionsPerWeek")
            def time_dialysed_element = create_node("TimeDialysed")
            def vascular_access_element = create_node("VascularAccess")
          end
        end
      end
    end
  end
end
