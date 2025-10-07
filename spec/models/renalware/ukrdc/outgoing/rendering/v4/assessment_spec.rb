module Renalware
  module UKRDC
    module Outgoing::Rendering::V4
      describe Assessment do
        include XmlSpecHelper

        let(:start_date) { 1.day.ago.to_date }
        let(:end_date) { Time.zone.today }

        it "renders a single Assessment XML fragment" do
          expected_xml = <<~XML.squish.gsub("> <", "><")
            <Assessment>
              <AssessmentStart>#{start_date.iso8601}</AssessmentStart>
              <AssessmentEnd>#{end_date.iso8601}</AssessmentEnd>
              <AssessmentType>
                <CodingStandard>RR50</CodingStandard>
                <Code>TPLTassess</Code>
                <Description>Suitability for renal transplant</Description>
              </AssessmentType>
              <AssessmentOutcome>
                <CodingStandard>RR51</CodingStandard>
                <Code>1</Code>
                <Description>Outcome 1</Description>
              </AssessmentOutcome>
            </Assessment>
          XML

          outcome = UKRDC::Assessments::Outcome.new(
            code: 1,
            description: "Outcome 1",
            assessment_type: UKRDC::Assessments::Type.new(
              code: "TPLTassess",
              description: "Suitability for renal transplant"
            )
          )

          actual_xml = format_xml(described_class.new(start_date:, end_date:, outcome:).xml)

          expect(actual_xml).to match_xml(expected_xml)
        end
      end
    end
  end
end
