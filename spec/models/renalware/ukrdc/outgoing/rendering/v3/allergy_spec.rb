# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::V3::Allergy do
        include XmlSpecHelper

        it do
          allergy = build(:allergy, patient: nil, description: "X", updated_by: nil)

          expected_xml = <<~XML.squish.gsub("> <", "><")
            <Allergy>
              <Clinician>
                <CodingStandard>LOCAL</CodingStandard>
                <Code/>
                <Description/>
              </Clinician>
              <FreeTextAllergy>X</FreeTextAllergy>
            </Allergy>
          XML

          xml = format_xml(described_class.new(allergy:).xml)

          expect(xml).to match_xml(expected_xml)
        end
      end
    end
  end
end
