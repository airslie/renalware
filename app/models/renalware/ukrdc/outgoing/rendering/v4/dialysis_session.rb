# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        module V4
          class DialysisSession < Rendering::Base
            pattr_initialize [:session!]

            def xml
              dialysis_session_element
            end

            private

            # The nested Diagnosis is correct.
            # <DialysisSession>
            #   <ProcedureType>
            #     <CodingStandard>SNOMED</CodingStandard>
            #     <Code>302497006</Code>
            #     <Description>Haemodialysis</Description>
            #   </ProcedureType>
            #   <ProcedureTime>2006-05-04T18:13:51.0</ProcedureTime>
            #   <EnteredAt>
            #     <CodingStandard>RR1+</CodingStandard>
            #     <Code>ABC123</Code>
            #     <Description>Test Hospital</Description>
            #   </EnteredAt>
            #   <UpdatedOn>2006-05-04T18:13:51.0</UpdatedOn>
            #   <ExternalId>787878787</ExternalId>
            # </DialysisSession>
            def dialysis_session_element
              create_node("DialysisSession") do |session_elem|
                session_elem << procedure_type_element
                session_elem << procedure_time_element
                session_elem << entered_at_element
                session_elem << external_id_element
                session_elem << vascular_access_element
                session_elem << vascular_access_site_element
                session_elem << time_dialysed_element
                # session_elem << attributes_element
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
                elem << create_node("CodingStandard", "LOCAL")
                elem << create_node("Code", session.hospital_unit_renal_registry_code)
              end
            end

            def external_id_element
              create_node("ExternalId", session.uuid)
            end

            def procedure_time_element
              create_node("ProcedureTime", session.started_at.iso8601)
            end

            def time_dialysed_element
              if session.duration_in_minutes.present?
                create_node("TimeDialysed", session.duration_in_minutes)
              end
            end

            def vascular_access_element
              if session.access_rr41_code.present?
                create_node("VascularAccess") do |elem|
                  elem << create_node("CodingStandard", "LOCAL")
                  elem << create_node("Code", session.access_rr02_code)
                end
              end
            end

            def vascular_access_site_element
              if session.access_rr41_code.present?
                create_node("VascularAccessSite") do |elem|
                  elem << create_node("CodingStandard", "LOCAL")
                  elem << create_node("Code", session.access_rr41_code)
                end
              end
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
                if session.sodium_content.present?
                  elem << create_node("QHD32", session.sodium_content) # Sodium in Dialysate
                end
                elem << create_node("QHD33", "U") # TODO: Lookup needling Method
              end
            end
            # rubocop:enable Metrics/AbcSize
          end
        end
      end
    end
  end
end
