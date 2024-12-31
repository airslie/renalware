module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class Procedures < Rendering::Base
          pattr_initialize [:patient!]

          def xml
            procedures_element
          end

          private

          def procedures_element
            create_node("Procedures") do |elem|
              dialysis_session_elements_inside(elem)
              transplant_operation_elements_inside(elem)
            end
          end

          def dialysis_session_elements_inside(elem)
            sessions = patient.finished_hd_sessions.map do |session|
              Renalware::HD::SessionPresenter.new(session)
            end
            elem << Rendering::DialysisSessions.new(
              patient: patient,
              sessions: sessions
            ).xml
          end

          def transplant_operation_elements_inside(elem)
            patient.transplant_operations.each do |operation|
              operation_presenter = Renalware::UKRDC::TransplantOperationPresenter.new(operation)
              elem << Rendering::Transplant.new(operation: operation_presenter).xml
            end
          end
        end
      end
    end
  end
end
