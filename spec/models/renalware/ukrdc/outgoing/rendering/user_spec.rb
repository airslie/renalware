module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::User do
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

          xml = format_xml(described_class.new(user: user).xml)

          expect(xml).to eq(expected_xml)
        end
      end
    end
  end
end
