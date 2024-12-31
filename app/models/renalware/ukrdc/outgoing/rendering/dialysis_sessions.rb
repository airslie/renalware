module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class DialysisSessions < Rendering::Base
          pattr_initialize [:patient!, :sessions!]

          def xml
            dialysis_sessions_element
          end

          private

          def dialysis_sessions_element
            create_node("DialysisSessions") do |sessions_elem|
              sessions_elem[:start] = patient.changes_since.to_date.iso8601
              sessions_elem[:stop] = patient.changes_up_until.to_date.iso8601

              sessions.each do |session|
                sessions_elem << Rendering::DialysisSession.new(session: session).xml
              end
            end
          end
        end
      end
    end
  end
end
