# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::EnteredAt do
        include XmlSpecHelper

        it do
          hospital_unit = build(:hospital_unit, unit_code: "U")
          expected_xml = <<~XML.squish.gsub("> <", "><")
            <EnteredAt>
              <CodingStandard>LOCAL</CodingStandard>
              <Code>U</Code>
            </EnteredAt>
          XML

          xml = format_xml(described_class.new(hospital_unit: hospital_unit).xml)

          expect(xml).to eq(expected_xml)
        end
      end
    end
  end
end
