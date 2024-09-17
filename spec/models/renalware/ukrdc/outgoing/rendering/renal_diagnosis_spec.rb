# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::RenalDiagnosis do
        include XmlSpecHelper

        context "when the patient has no PRD" do
          it "renders nothing" do
            patient = instance_double(PatientPresenter, prd_description_code: nil)

            xml = described_class.new(patient: patient).xml

            expect(xml).to be_nil
          end
        end

        context "when the patient has a PRD" do
          it "renders a RenalDiagnosis element" do
            patient = instance_double(
              PatientPresenter,
              prd_description_code: "XYZ",
              prd_description_term: "ABC",
              first_seen_on: Time.zone.parse("2019-12-28").to_datetime
            )

            expected_xml = <<~XML.squish.gsub("> <", "><")
              <RenalDiagnosis>
                <Diagnosis>
                  <CodingStandard>EDTA2</CodingStandard>
                  <Code>XYZ</Code>
                  <Description>ABC</Description>
                </Diagnosis>
                <IdentificationTime>2019-12-28T00:00:00+00:00</IdentificationTime>
              </RenalDiagnosis>
            XML

            xml = format_xml(described_class.new(patient: patient).xml)

            expect(xml).to eq(expected_xml)
          end
        end
      end
    end
  end
end
