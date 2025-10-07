# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        module V4
          class DialysisPrescriptions < Rendering::Base
            pattr_initialize [:patient!]

            def xml
              dialysis_sessions_element
            end

            private

            def dialysis_sessions_element
              create_node("DialysisPrescriptions") do |elem|
                elem[:start] = patient.changes_since.to_date.iso8601
                elem[:stop] = patient.changes_up_until.to_date.iso8601

                hd_prescriptions.each do |prescription|
                  elem << DialysisPrescription.new(prescription:).xml
                end
              end
            end

            def hd_prescriptions = []
          end
        end
      end
    end
  end
end
