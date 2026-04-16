require "builder"

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::V4::VascularAccess do
        include XmlSpecHelper

        it "renders a vascular access procedure with supported attributes" do
          procedure = create(
            :access_procedure,
            performed_on: Date.parse("2021-01-02"),
            first_used_on: Date.parse("2021-01-03"),
            failed_on: Date.parse("2021-01-04"),
            pd_catheter_insertion_technique: create(
              :catheter_insertion_technique,
              code: 2,
              description: "Laparoscopic"
            )
          )

          expected_xml = <<~XML.squish.gsub("> <", "><")
            <VascularAccess>
              <ProcedureType>
                <CodingStandard>SNOMED</CodingStandard>
                <Code>27929005</Code>
                <Description>Construction of arteriovenous fistula</Description>
              </ProcedureType>
              <ProcedureTime>2021-01-02T00:00:00+00:00</ProcedureTime>
              <Attributes>
                <ACC19>2021-01-03T00:00:00+00:00</ACC19>
                <ACC20>2021-01-04T00:00:00+00:00</ACC20>
                <ACC30>2</ACC30>
              </Attributes>
            </VascularAccess>
          XML

          actual_xml = format_xml(described_class.new(procedure:).xml)

          expect(actual_xml).to match_xml(expected_xml)
        end
      end
    end
  end
end
