module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::Allergy do
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

          xml = format_xml(described_class.new(allergy: allergy).xml)

          expect(xml).to eq(expected_xml)
        end
      end
    end
  end
end
