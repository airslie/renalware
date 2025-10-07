module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::V4::EnteredAt do
        include XmlSpecHelper

        it do
          hospital_unit = build(:hospital_unit, unit_code: "U")
          expected_xml = <<~XML.squish.gsub("> <", "><")
            <EnteredAt>
              <CodingStandard>LOCAL</CodingStandard>
              <Code>U</Code>
            </EnteredAt>
          XML

          xml = format_xml(described_class.new(hospital_unit:).xml)

          expect(xml).to match_xml(expected_xml)
        end
      end
    end
  end
end
