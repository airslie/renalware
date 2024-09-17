# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::Name do
        include XmlSpecHelper

        it do
          patient = Patient.new(
            family_name: "F",
            given_name: "G",
            suffix: "S",
            title: "T"
          )

          expected_xml = <<~XML.squish.gsub("> <", "><")
            <Name use="L">
              <Prefix>T</Prefix>
              <Family>F</Family>
              <Given>G</Given>
              <Suffix>S</Suffix>
            </Name>
          XML

          xml = format_xml(described_class.new(nameable: patient).xml)

          expect(xml).to eq(expected_xml)
        end
      end
    end
  end
end
