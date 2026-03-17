# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        module V3
          class Medication < Rendering::Base
            pattr_initialize [:prescription!]

            def xml
              medication_element
            end

            private

            def medication_element # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
              create_node("Medication").tap do |medication|
                medication << create_node("FromTime", prescription.prescribed_on.to_datetime)
                if prescription.terminated_or_marked_for_termination?
                  medication << create_node("ToTime", prescription.terminated_on&.to_datetime)
                end
                medication << entering_organisation_element
                medication << route_element
                medication << product_type_element
                medication << create_node("Frequency", prescription.frequency)
                medication << comments
                medication << create_node("DoseQuantity", prescription.dose_amount&.strip)
                medication << dose_uom_element
                medication << create_node("ExternalId", prescription.id)
              end
            end

            def entering_organisation_element
              create_node("EnteringOrganization") do |org|
                org << create_node("CodingStandard", "ODS")
                org << create_node("Code", Renalware.config.ukrdc_site_code)
              end
            end

            def route_element
              create_node("Route") do |route|
                if prescription.medication_route&.rr_code
                  route << create_node("CodingStandard", "RR22")
                  route << create_node("Code", prescription.medication_route&.rr_code)
                end
              end
            end

            def product_type_element
              create_node("DrugProduct") do |drug|
                drug << create_node("Generic", prescription.drug)
              end
            end

            def comments
              comments = [
                prescription.dose_amount,
                prescription.dose_unit&.text,
                prescription.frequency
              ].compact.join(" ")
              create_node("Comments", comments)
            end

            # Map our dm+d unit of measure to an equivalent one if there is one.
            # Given a dmd uom like 'litre', try to match against UKRDC UOM attributes
            # - name eg L => no match
            # - description eg "litres" => no match
            # - alias array eg ["litre"] => match
            def dose_uom_element
              dmd_uom = prescription.unit_of_measure
              return if dmd_uom.blank?

              ukrdc_uom = MeasurementUnit.for_dmd_name(dmd_uom.name)
              return if ukrdc_uom.blank?

              create_node("DoseUoM") do |uom|
                uom << create_node("CodingStandard", "LOCAL")
                uom << create_node("Code", ukrdc_uom.name)
                uom << create_node("Description", ukrdc_uom.description)
              end
            end
          end
        end
      end
    end
  end
end
