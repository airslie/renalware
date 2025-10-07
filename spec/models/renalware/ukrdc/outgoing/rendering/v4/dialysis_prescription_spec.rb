require "builder"

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::V4::DialysisPrescription do
        include XmlSpecHelper

        it do
          expected_xml = <<~XML.squish.gsub("> <", "><")
            <DialysisPrescription>
              <EnteredOn></EnteredOn>
              <FromTime></FromTime>
              <ToTime></ToTime>
              <SessionType></SessionType>
              <SessionsPerWeek></SessionsPerWeek>
              <TimeDialysed></TimeDialysed>
              <VascularAccess></VascularAccess>
            </DialysisPrescription>
          XML
          hd_prescription = NullObject.instance
          actual_xml = format_xml(described_class.new(hd_prescription:).xml)

          expect(actual_xml).to match_xml(expected_xml)
        end
      end
    end
  end
end
