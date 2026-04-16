# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        module V4
          class VascularAccess < Rendering::Base
            pattr_initialize [:procedure!]

            def xml
              vascular_access_element
            end

            private

            def vascular_access_element
              create_node("VascularAccess") do |elem|
                elem << procedure_type_element
                elem << procedure_time_element
                elem << attributes_element
              end
            end

            # TODO: we need to determine the correct code and description to use here.
            # This is currently hardcoded to the code for "Construction of arteriovenous fistula"
            # as an example.
            def procedure_type_element
              create_node("ProcedureType") do |elem|
                elem << create_node("CodingStandard", "SNOMED")
                elem << create_node("Code", "27929005")
                elem << create_node("Description", "Construction of arteriovenous fistula")
              end
            end

            def procedure_time_element
              create_node("ProcedureTime", procedure.performed_on.to_datetime.iso8601)
            end

            def attributes_element
              return unless attribute_values.values.any?(&:present?)

              create_node("Attributes") do |elem|
                attribute_values.each do |key, value|
                  next if value.blank?

                  elem << create_node(key, value)
                end
              end
            end

            def attribute_values
              {
                "ACC19" => procedure.first_used_on&.to_datetime&.iso8601,
                "ACC20" => procedure.failed_on&.to_datetime&.iso8601,
                "ACC30" => procedure.pd_catheter_insertion_technique&.code&.to_s
              }
            end
          end
        end
      end
    end
  end
end
