module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class Medication < Rendering::Base
          pattr_initialize [:prescription!]

          def xml
            medication_element
          end

          private

          # rubocop:disable Metrics/AbcSize
          def medication_element
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
          # rubocop:enable Metrics/AbcSize

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

          def dose_uom_element
            return if prescription.dose_unit.blank?

            create_node("DoseUoM") do |uom|
              uom << create_node("CodingStandard", "LOCAL")
              uom << create_node("Code", prescription.dose_unit&.text)
              uom << create_node("Description", prescription.dose_unit)
            end
          end
        end
      end
    end
  end
end
