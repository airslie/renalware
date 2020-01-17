# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class DialysisSession < Rendering::Base
          pattr_initialize [:session!]

          def xml
            dialysis_session_element
          end

          private

          # The nested Diagnosis is correct.
          def dialysis_session_element
            create_node("DialysisSession") do |session_elem|
              session_elem["start"] = session.performed_on_date
              session_elem["stop"] = session.performed_on_date
              session_elem << procedure_type_element
              session_elem << clinician_element
              session_elem << procedure_time_element
              session_elem << entered_by_element
              session_elem << entered_at_element
              session_elem << external_id_element
              session_elem << attributes_element
            end
          end

          def procedure_type_element
            create_node("ProcedureType") do |elem|
              elem << create_node("CodingStandard", "SNOMED")
              elem << create_node("Code", "302497006")
              elem << create_node("Description", "Haemodialysis")
            end
          end

          def clinician_element
            create_node("Clinician") do |elem|
              elem << create_node("Description", session.updated_by)
            end
          end

          def entered_at_element
            create_node("EnteredAt") do |elem|
              elem << create_node("Code", session.hospital_unit_renal_registry_code)
            end
          end

          def entered_by_element
            Rendering::EnteredBy.new(user: session.updated_by).xml
          end

          def external_id_element
            create_node("ExternalId", session.uuid)
          end

          def procedure_time_element
            create_node("ProcedureTime", session.start_datetime.to_datetime)
          end

          # rubocop:disable Metrics/AbcSize
          def attributes_element
            create_node("Attributes") do |elem|
              elem << create_node("QHD19", session.had_intradialytic_hypotension?)
              elem << create_node("QHD20", session.access_rr02_code)
              elem << create_node("QHD21", session.access_rr41_code)
              elem << create_node("QHD22", "N") # Access in two sites simultaneously
              elem << create_node("QHD30", coerce_to_integer(session.blood_flow))
              elem << create_node("QHD31", coerce_to_integer(session.duration_in_minutes))
              elem << create_node("QHD32", session.sodium_content) # Sodium in Dialysate
              elem << create_node("QHD33") # TODO: Needling Method
            end
          end
          # rubocop:enable Metrics/AbcSize
        end
      end
    end
  end
end
