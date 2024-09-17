# frozen_string_literal: true

# rubocop:disable RSpec/ExampleLength
module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::LabOrder do
        include XmlSpecHelper

        before { Renalware.config.ukrdc_sending_facility_name = "Test" }

        let(:patient) { instance_double(UKRDC::PatientPresenter, current_modality_hd?: true) }

        def build_pathology_request_with_an_hgb_observation
          request = build_stubbed(
            :pathology_observation_request,
            :full_blood_count_with_observations,
            requestor_order_number: "1",
            requested_at: Time.zone.parse("2019-01-01 00:00:00")
          )
          request.description.bottle_type = :serum
          desc = build_stubbed(
            :pathology_observation_description,
            measurement_unit: build_stubbed(:pathology_measurement_unit, name: "L"),
            code: "HGB",
            name: "HGB desc"
          )
          observation = build_stubbed(
            :pathology_observation,
            description: desc,
            observed_at: request.requested_at,
            updated_at: request.requested_at,
            result: "  6.1"
          )
          allow(request).to receive(:observations).and_return [observation]
          UKRDC::PathologyObservationRequestPresenter.new(request)
        end

        it do
          request = build_pathology_request_with_an_hgb_observation
          placer_id = "1-20190101000000000-#{request.description_id}"
          expected_xml = <<~XML.squish.gsub("> <", "><")
            <LabOrder>
              <ReceivingLocation>
                <CodingStandard>RR1+</CodingStandard>
                <Code>Test</Code>
                <Description>Test</Description>
              </ReceivingLocation>
              <PlacerId>#{placer_id}</PlacerId>
              <OrderCategory>
                <CodingStandard>LOCAL</CodingStandard>
                <Code>FBC</Code>
              </OrderCategory>
              <SpecimenCollectedTime>2019-01-01T00:00:00+00:00</SpecimenCollectedTime>
              <SpecimenSource>serum</SpecimenSource>
              <ResultItems>
                <ResultItem>
                  <EnteredOn>2019-01-01T00:00:00+00:00</EnteredOn>
                  <PrePost>PRE</PrePost>
                  <ServiceId>
                    <CodingStandard>UKRR</CodingStandard>
                    <Code>HGB</Code>
                    <Description>HGB desc</Description>
                  </ServiceId>
                  <ResultValue>6.1</ResultValue>
                  <ResultValueUnits>L</ResultValueUnits>
                  <ObservationTime>2019-01-01T00:00:00+00:00</ObservationTime>
                </ResultItem>
              </ResultItems>
              <EnteredOn>2019-01-01T00:00:00+00:00</EnteredOn>
              <EnteredAt>
                <CodingStandard>RR1+</CodingStandard>
                <Code>Test</Code>
                <Description>Test</Description>
              </EnteredAt>
              <EnteringOrganization>
                <CodingStandard>RR1+</CodingStandard>
                <Code>Test</Code>
                <Description>Test</Description>
              </EnteringOrganization>
              <ExternalId>#{placer_id}</ExternalId>
            </LabOrder>
          XML

          actual_xml = format_xml(described_class.new(patient: patient, request: request).xml)

          if actual_xml != expected_xml
            p actual_xml
            p expected_xml
          end

          expect(actual_xml).to eq(expected_xml)
        end
      end
    end
  end
end
# rubocop:enable RSpec/ExampleLength
