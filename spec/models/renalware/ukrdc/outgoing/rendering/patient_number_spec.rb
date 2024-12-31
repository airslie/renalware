module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::PatientNumber do
        include XmlSpecHelper

        it do
          expected_xml = <<~XML.squish.gsub("> <", "><")
            <PatientNumber>
              <Number>123</Number>
              <Organization>X</Organization>
              <NumberType>Y</NumberType>
            </PatientNumber>
          XML

          actual_xml = described_class.new(number: "123", organisation: "X", type: "Y").xml

          expect(format_xml(actual_xml)).to eq(expected_xml)
        end
      end
    end
  end
end
