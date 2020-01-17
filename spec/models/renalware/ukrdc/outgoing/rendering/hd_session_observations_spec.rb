# frozen_string_literal: true

require "rails_helper"

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::HDSessionObservations do
        include XmlSpecHelper

        describe "pre and post body weight measurements" do
          it "renders with with the correct pre/post indicator" do
            session = Renalware::HD::Session::Closed.new(
              performed_on: "2018-01-01",
              start_time: "12:01",
              end_time: "16:01"
            )
            session.document.observations_before.weight = "60 approx"
            session.document.observations_after.weight = "61.1 kg"

            expected_xml = <<~XML.squish.gsub("> <", "><")
              <X>
                <Observation>
                  <ObservationTime>2018-01-01T12:01:00+00:00</ObservationTime>
                  <ObservationCode>
                    <CodingStandard>UKRR</CodingStandard>
                    <Code>QBLG1</Code>
                    <Description>Body weight Measured</Description>
                  </ObservationCode>
                  <ObservationValue>60.0</ObservationValue>
                  <ObservationUnits>Kg</ObservationUnits>
                  <PrePost>PRE</PrePost>
                </Observation>
                <Observation>
                  <ObservationTime>2018-01-01T16:01:00+00:00</ObservationTime>
                  <ObservationCode>
                    <CodingStandard>UKRR</CodingStandard>
                    <Code>QBLG1</Code>
                    <Description>Body weight Measured</Description>
                  </ObservationCode>
                  <ObservationValue>61.1</ObservationValue>
                  <ObservationUnits>Kg</ObservationUnits>
                  <PrePost>POST</PrePost>
                </Observation>
              </X>
            XML

            parent = Ox::Element.new("X")
            described_class.new(session: session).create_observation_nodes_under(parent)

            actual_xml = format_xml(parent)

            expect(actual_xml).to eq(expected_xml)
          end
        end
      end
    end
  end
end
