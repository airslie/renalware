# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::Transplant do
        include XmlSpecHelper

        it "renders a Treatment element" do
          operation = Transplants::RecipientOperation.new(
            operation_type: :kidney,
            performed_on: "2017-02-23",
            hospital_centre: Hospitals::Centre.new(code: "X", name: "Y")
          )
          operation.document.donor.type = :live_related
          operation_presenter = Renalware::UKRDC::TransplantOperationPresenter.new(operation)

          expected_xml = <<~XML.squish.gsub("> <", "><")
            <Transplant>
              <ProcedureType>
                <CodingStandard>SNOMED</CodingStandard>
                <Code>70536003</Code>
                <Description>Kidney Transplant</Description>
              </ProcedureType>
              <ProcedureTime>2017-02-23T00:00:00+00:00</ProcedureTime>
              <EnteredAt>
                <CodingStandard>ODS</CodingStandard>
                <Code>X</Code>
                <Description>Y</Description>
              </EnteredAt>
              <Attributes>
                <TRA77>LIVE</TRA77>
              </Attributes>
            </Transplant>
          XML

          xml = format_xml(
            described_class.new(operation: operation_presenter).xml
          )

          expect(xml).to eq(expected_xml)
        end
      end
    end
  end
end
