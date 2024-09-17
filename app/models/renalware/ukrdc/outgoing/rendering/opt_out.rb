# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class OptOut < Rendering::Base
          pattr_initialize [:patient!]

          MISSING_DATE = "1900-01-01"

          def xml = element

          private

          def element
            return unless opted_out?

            Ox::Element.new("OptOut").tap do |elem|
              elem << entered_by_element
              elem << entered_at_element
              elem << program_name_element
              elem << program_description_element
              elem << from_time_element
              elem << to_time_element
            end
          end

          def entered_by_element
            return if patient.renalreg_recorded_by.blank?

            create_node("EnteredBy") do |elem|
              elem << create_node("CodingStandard", "LOCAL")
              elem << create_node("Code", patient.renalreg_recorded_by)
            end
          end

          def entered_at_element
            create_node("EnteredAt").tap do |elem|
              elem << create_node("CodingStandard", "RR1+")
              elem << create_node("Code", Renalware.config.ukrdc_sending_facility_name)
            end
          end

          def program_name_element        = create_node("ProgramName", "UKRR")
          def program_description_element = nil
          def from_time_element           = create_node("FromTime", opted_out_at.iso8601)
          def to_time_element             = nil
          def opted_out?                  = !patient.send_to_renalreg?
          def opted_out_at                = patient.renalreg_decision_on || Date.parse(MISSING_DATE)
        end
      end
    end
  end
end
