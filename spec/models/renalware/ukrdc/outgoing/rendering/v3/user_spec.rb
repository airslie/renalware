# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::V3::User do
        include XmlSpecHelper

        it do
          user = Renalware::User.new(username: "U", family_name: "F", given_name: "G")
          expected_xml = <<~XML.squish.gsub("> <", "><")
            <User>
              <CodingStandard>LOCAL</CodingStandard>
              <Code>U</Code>
              <Description>F, G</Description>
            </User>
          XML

          xml = format_xml(described_class.new(user:).xml)

          expect(xml).to match_xml(expected_xml)
        end
      end
    end
  end
end
