# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::Treatment do
        include XmlSpecHelper

        it "renders a Treatment element" do
          treatment = UKRDC::Treatment.new(
            discharge_reason_code: "9",
            modality_code: UKRDC::ModalityCode.new(txt_code: "1"),
            modality_id: 1,
            started_on: Time.zone.parse("2019-12-13")
          )
          Renalware.config.ukrdc_site_code = "XXX"

          expected_xml = <<~XML.squish.gsub("> <", "><")
            <Treatment>
              <EncounterNumber>1</EncounterNumber>
              <EncounterType>N</EncounterType>
              <FromTime>2019-12-13</FromTime>
              <HealthCareFacility>
                <CodingStandard>ODS</CodingStandard>
                <Code>XXX</Code>
              </HealthCareFacility>
              <AdmitReason>
                <CodingStandard>CF_RR7_TREATMENT</CodingStandard>
                <Code>1</Code>
              </AdmitReason>
              <DischargeReason>
                <CodingStandard>CF_RR7_DISCHARGE</CodingStandard>
                <Code>9</Code>
              </DischargeReason>
            </Treatment>
          XML

          actual_xml = format_xml(
            described_class.new(treatment: treatment).xml
          )

          expect(actual_xml).to eq(expected_xml)
        end

        context "when an encounter_number is supplied" do
          it "uses encounter_number rather the modality id" do
            treatment = UKRDC::Treatment.new(
              discharge_reason_code: "9",
              modality_id: 1,
              started_on: Time.zone.parse("2019-12-13")
            )

            xml = format_xml(
              described_class.new(treatment: treatment, encounter_number: "123").xml
            )

            expect(xml).to match("<EncounterNumber>123</EncounterNumber>")
          end
        end

        context "when the treatment has a hospital_unit present" do
          it "uses that rather than Renalware.config.ukrdc_site_code" do
            treatment = UKRDC::Treatment.new(
              discharge_reason_code: "9",
              modality_id: 1,
              started_on: Time.zone.parse("2019-12-13"),
              hospital_unit: Hospitals::Unit.new(renal_registry_code: "X123")
            )

            xml = format_xml(
              described_class.new(treatment: treatment).xml
            )

            expect(xml).to match("<Code>X123</Code>")
          end
        end

        context "when an attributes has is supplied" do
          it "renders them inside an Attributes element provided the hash value is present" do
            treatment = UKRDC::Treatment.new(
              discharge_reason_code: "9",
              modality_id: 1,
              started_on: Time.zone.parse("2019-12-13"),
              hospital_unit: Hospitals::Unit.new(renal_registry_code: "X123")
            )

            xml = format_xml(
              described_class.new(
                treatment: treatment,
                attributes: { "QBL05" => "TEST", "QBL99" => "", "QBL100" => nil }
              ).xml
            )

            expect(xml).to match("<Attributes><QBL05>TEST</QBL05></Attributes>")
          end
        end
      end
    end
  end
end
