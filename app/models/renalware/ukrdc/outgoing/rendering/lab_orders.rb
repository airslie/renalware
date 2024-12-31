module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class LabOrders < Rendering::Base
          pattr_initialize [:patient!]

          def xml
            lab_orders_element
          end

          private

          def lab_orders_element
            create_node("LabOrders") do |lab_orders|
              lab_orders[:start] = patient.changes_since.to_date.iso8601
              lab_orders[:stop] = patient.changes_up_until.to_date.iso8601

              patient.observation_requests.each do |request|
                lab_orders << Rendering::LabOrder.new(patient: patient, request: request).xml
              end
            end
          end
        end
      end
    end
  end
end
