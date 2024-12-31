module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class Transplant < Rendering::Base
          pattr_initialize [:operation!]

          def xml
            transplant_element
          end

          private

          def transplant_element
            create_node("Transplant") do |elem|
              elem << procedure_type_element
              elem << procedure_time_element
              elem << entered_at_element
              elem << attributes_element
            end
          end

          def procedure_type_element
            return if operation.operation_type.blank?

            create_node("ProcedureType") do |elem|
              elem << create_node("CodingStandard", "SNOMED")
              elem << create_node("Code", operation.procedure_type_snomed_code.to_i)
              elem << create_node("Description", operation.procedure_type_name)
            end
          end

          def procedure_time_element
            create_node("ProcedureTime", operation.performed_at&.iso8601)
          end

          def entered_at_element
            return if operation.hospital_centre_code.blank?

            create_node("EnteredAt") do |elem|
              elem << create_node("CodingStandard", "ODS")
              elem << create_node("Code", operation.hospital_centre_code)
              elem << create_node("Description", operation.hospital_centre_name)
            end
          end

          def attributes_element
            create_node("Attributes") do |elem|
              if operation.nhsbt_type.present?
                elem << create_node("TRA77", operation.nhsbt_type)
              end
            end
          end

          # Not sending TRA76 yet as defined as datetime in XSD and needs changing there.
          # if operation.rr_tra76_options.present?
          #   xml.TRA76 do
          #     xml.CodingStandard "CF_RR7_TREATMENT"
          #     xml.Code operation.rr_tra76_options[:code]
          #     xml.Description operation.rr_tra76_options[:description]
          #   end
          # end
        end
      end
    end
  end
end
