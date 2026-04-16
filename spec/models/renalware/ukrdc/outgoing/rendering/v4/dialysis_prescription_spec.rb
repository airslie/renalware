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
              <SessionType>HD</SessionType>
              <SessionsPerWeek></SessionsPerWeek>
              <VascularAccess></VascularAccess>
            </DialysisPrescription>
          XML
          hd_profile = NullObject.instance
          actual_xml = format_xml(described_class.new(hd_profile:).xml)

          expect(actual_xml).to match_xml(expected_xml)
        end
      end
    end
  end
end
