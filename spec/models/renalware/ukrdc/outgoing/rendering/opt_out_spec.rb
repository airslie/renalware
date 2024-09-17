# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::OptOut do
        include XmlSpecHelper

        context "when patient is not opted out of Renal Reg" do
          it "renders nothing" do
            patient = build(:patient, send_to_renalreg: true)

            expect(described_class.new(patient: patient).xml).to be_nil
          end
        end

        context "when patient has opted out of Renal Reg" do
          context "when a decision date was not specified" do
            it "uses 01/01/1900" do
              patient = build(:patient, send_to_renalreg: false, renalreg_decision_on: nil)
              expected_xml = <<~XML.squish.gsub("> <", "><")
                <OptOut>
                  <EnteredAt>
                    <CodingStandard>RR1+</CodingStandard>
                    <Code>Test</Code>
                  </EnteredAt>
                  <ProgramName>UKRR</ProgramName>
                  <FromTime>1900-01-01</FromTime>
                </OptOut>
              XML

              xml = format_xml(described_class.new(patient: patient).xml)

              expect(xml).to eq(expected_xml)
            end
          end

          it do
            patient = build(:patient, send_to_renalreg: false, renalreg_decision_on: "2024-07-16")
            expected_xml = <<~XML.squish.gsub("> <", "><")
              <OptOut>
                <EnteredAt>
                  <CodingStandard>RR1+</CodingStandard>
                  <Code>Test</Code>
                </EnteredAt>
                <ProgramName>UKRR</ProgramName>
                <FromTime>2024-07-16</FromTime>
              </OptOut>
            XML

            xml = format_xml(described_class.new(patient: patient).xml)

            expect(xml).to eq(expected_xml)
          end
        end
      end
    end
  end
end
