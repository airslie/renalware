# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::Diagnosis do
        include XmlSpecHelper

        it do
          expected_xml = <<~XML.squish.gsub("> <", "><")
            <Diagnosis>
              <Diagnosis>
                <CodingStandard>X</CodingStandard>
                <Code>Y</Code>
                <Description>Z</Description>
              </Diagnosis>
              <OnsetTime>O</OnsetTime>
              <IdentificationTime>I</IdentificationTime>
            </Diagnosis>
          XML

          xml = format_xml(
            described_class.new(
              coding_standard: "X",
              code: "Y",
              description: "Z",
              onset_time: "O",
              identification_time: "I"
            ).xml
          )

          expect(xml).to eq(expected_xml)
        end
      end
    end
  end
end
