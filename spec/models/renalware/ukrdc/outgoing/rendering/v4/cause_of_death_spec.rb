module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::V4::CauseOfDeath do
        include XmlSpecHelper

        context "when there is a primary cause of death" do
          it "renders a CauseOfDeath element" do
            cause = Deaths::Cause.new(code: 1, created_at: Time.zone.parse("2019-01-01"))

            expected_xml = <<~XML.squish.gsub("> <", "><")
              <CauseOfDeath>
                <DiagnosisType>PRIMARY</DiagnosisType>
                <Diagnosis>
                  <CodingStandard>EDTA_COD</CodingStandard>
                  <Code>1</Code>
                </Diagnosis>
                <EnteredOn>2019-01-01T00:00:00+00:00</EnteredOn>
              </CauseOfDeath>
            XML

            xml = format_xml(described_class.new(cause:).xml)

            expect(xml).to match_xml(expected_xml)
          end
        end

        context "when there is a secondary cause of death" do
          it "renders a secondary DiagnosisType" do
            cause = Deaths::Cause.new(code: 12, created_at: Time.zone.parse("2019-01-01"))

            expected_xml = <<~XML.squish.gsub("> <", "><")
              <CauseOfDeath>
                <DiagnosisType>SECONDARY</DiagnosisType>
                <Diagnosis>
                  <CodingStandard>EDTA_COD</CodingStandard>
                  <Code>12</Code>
                </Diagnosis>
                <EnteredOn>2019-01-01T00:00:00+00:00</EnteredOn>
              </CauseOfDeath>
            XML

            xml = format_xml(described_class.new(cause:, diagnosis_type: "SECONDARY").xml)

            expect(xml).to match_xml(expected_xml)
          end
        end
      end
    end
  end
end
