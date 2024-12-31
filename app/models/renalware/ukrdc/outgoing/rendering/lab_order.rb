# rubocop:disable Metrics/AbcSize
module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class LabOrder < Rendering::Base
          pattr_initialize [:patient!, :request!]

          def xml
            lab_order_element
          end

          private

          def lab_order_element
            Ox::Element.new("LabOrder").tap do |lab_order|
              lab_order << receiving_location_element
              lab_order << create_node("PlacerId", request.placer_id)
              lab_order << order_category_element
              lab_order << create_node("SpecimenCollectedTime", request.requested_at&.iso8601)
              lab_order << create_node("SpecimenSource", request.description.bottle_type)
              lab_order << result_items_element
              lab_order << create_node("EnteredOn", request.requested_at.iso8601)
              lab_order << entered_at_element
              lab_order << entering_organisation_element
              lab_order << create_node("ExternalId", request.placer_id)
            end
          end

          def order_category_element
            create_node("OrderCategory") do |category|
              category << create_node("CodingStandard", "LOCAL")
              category << create_node("Code", request.description.code)
            end
          end

          def result_items_element
            create_node("ResultItems") do |items|
              request.observations.each do |observation|
                items << result_item_element_for(observation)
              end
            end
          end

          def result_item_element_for(observation)
            observation = Renalware::Pathology::ObservationPresenter.new(observation)
            observation = Renalware::UKRDC::PathologyObservationPresenter.new(observation)
            create_node("ResultItem") do |item|
              item << create_node("EnteredOn", observation.updated_at&.iso8601)
              item << create_node(
                "PrePost",
                observation.pre_post(patient_is_on_hd: patient.current_modality_hd?)
              )
              item << service_id_element_for(observation)
              rr_type_value_elements_for(observation, append_to: item)
              item << create_node("ObservationTime", observation.observed_at&.iso8601)
            end
          end

          def service_id_element_for(observation)
            create_node("ServiceId") do |elem|
              elem << create_node("CodingStandard", observation.coding_standard)
              elem << create_node("Code", observation.code)
              elem << create_node("Description", observation.description_name)
            end
          end

          # If the rr_type of the observation_description is interpretation (ie an interpreted
          # result like POS NEG then output the interpretation_code
          def rr_type_value_elements_for(observation, append_to:)
            if observation.rr_type_interpretation?
              append_to << create_node("InterpretationCodes", observation.interpretation_code)
            else
              append_to << create_node("ResultValue", observation.result.strip)
              append_to << create_node("ResultValueUnits", observation.measurement_unit_name)
            end
          end

          def entered_at_element
            create_node("EnteredAt").tap do |elem|
              elem << create_node("CodingStandard", "RR1+")
              elem << create_node("Code", Renalware.config.ukrdc_sending_facility_name)
              elem << create_node("Description", Renalware.config.ukrdc_sending_facility_name)
            end
          end

          def entering_organisation_element
            create_node("EnteringOrganization").tap do |elem|
              elem << create_node("CodingStandard", "RR1+")
              elem << create_node("Code", Renalware.config.ukrdc_sending_facility_name)
              elem << create_node("Description", Renalware.config.ukrdc_sending_facility_name)
            end
          end

          def receiving_location_element
            create_node("ReceivingLocation").tap do |elem|
              elem << create_node("CodingStandard", "RR1+")
              elem << create_node("Code", Renalware.config.ukrdc_sending_facility_name)
              elem << create_node("Description", Renalware.config.ukrdc_sending_facility_name)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/AbcSize
