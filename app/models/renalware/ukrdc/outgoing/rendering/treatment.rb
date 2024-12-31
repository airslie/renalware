module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class Treatment < Rendering::Base
          pattr_initialize [:treatment!, :encounter_number, :attributes]

          def xml
            treatment_element
          end

          private

          # rubocop:disable Metrics/AbcSize
          def treatment_element
            create_node("Treatment") do |elem|
              elem << create_node("EncounterNumber", encounter_number || treatment.modality_id)
              elem << create_node("EncounterType", "N")
              elem << create_node("FromTime", treatment.started_on&.iso8601)
              if treatment.ended_on.present?
                elem << create_node("ToTime", treatment.ended_on&.iso8601)
              end
              elem << healthcare_facility_element
              elem << admin_reason_element
              elem << discharge_reason_element
              elem << attributes_element
            end
          end
          # rubocop:enable Metrics/AbcSize

          def healthcare_facility_element
            create_node("HealthCareFacility") do |elem|
              elem << create_node("CodingStandard", "ODS")
              code = treatment.hospital_unit&.renal_registry_code || default_unit_code
              elem << create_node("Code", code)
            end
          end

          def admin_reason_element
            create_node("AdmitReason") do |elem|
              elem << create_node("CodingStandard", "CF_RR7_TREATMENT")
              elem << create_node("Code", treatment.modality_code&.txt_code)
            end
          end

          def discharge_reason_element
            return if treatment&.discharge_reason_code.blank?

            create_node("DischargeReason") do |elem|
              elem << create_node("CodingStandard", "CF_RR7_DISCHARGE")
              elem << create_node("Code", treatment.discharge_reason_code)
            end
          end

          # Attributes is a hash eg { "QBL05" => "HOME" }
          def attributes_element
            return if attributes.blank?
            return unless attributes.values.detect(&:present?)

            create_node("Attributes") do |elem|
              attributes.each do |key, value|
                next if value.blank?

                elem << create_node(key, value)
              end
            end
          end

          def default_unit_code
            Renalware.config.ukrdc_site_code
          end
        end
      end
    end
  end
end
