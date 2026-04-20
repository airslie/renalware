require "builder"

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::V4::Procedures do
        include XmlSpecHelper

        let(:changes_since) { Time.zone.parse("2021-01-01 10:01:01") }
        let(:changes_up_until) { Time.zone.parse("2021-02-01 09:02:02") }

        def build_patient(finished_hd_sessions:, transplant_operations:)
          instance_double(
            Renalware::UKRDC::PatientPresenter,
            changes_since:,
            changes_up_until:,
            finished_hd_sessions:,
            transplant_operations:,
            access_procedures: []
          )
        end

        def build_hd_session
          dialysate = build_stubbed(:hd_dialysate, sodium_content: 100)
          session = Renalware::HD::Session::Closed.new(
            started_at: "2018-11-01 11:00",
            stopped_at: "2018-11-01 13:00",
            duration: 121,
            dialysate:,
            updated_by: build_stubbed(:user, family_name: "F", given_name: "G", username: "U"),
            hospital_unit: build_stubbed(:hospital_unit, unit_code: "U")
          )
          session.document.dialysis.blood_flow = "no"
          session.document.complications.had_intradialytic_hypotension = false
          allow(session).to receive(:uuid).and_return("UUID")
          session
        end

        def build_transplant_operation
          operation = Transplants::RecipientOperation.new(
            operation_type: :kidney,
            performed_on: "2017-02-23",
            cold_ischaemic_time: 45.minutes,
            hospital_centre: Hospitals::Centre.new(code: "X", name: "Y")
          )
          operation.document.donor.type = :live_related
          operation
        end

        def expected_xml_for_session_and_transplant
          <<~XML.squish.gsub("> <", "><")
            <Procedures>
              <DialysisSessions start="2021-01-01" stop="2021-02-01">
                <DialysisSession>
                  <ProcedureType>
                    <CodingStandard>SNOMED</CodingStandard>
                    <Code>302497006</Code>
                    <Description>Haemodialysis</Description>
                  </ProcedureType>
                  <ProcedureTime>2018-11-01T11:00:00+00:00</ProcedureTime>
                  <EnteredAt>
                    <CodingStandard>LOCAL</CodingStandard>
                    <Code>DOV</Code>
                  </EnteredAt>
                  <ExternalId>UUID</ExternalId>
                  <SymtomaticHypotension>N</SymtomaticHypotension>
                  <TimeDialysed>121</TimeDialysed>
                </DialysisSession>
              </DialysisSessions>
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
                <DonorType>LIVE</DonorType>
                <ColdIschaemicTime>45</ColdIschaemicTime>
              </Transplant>
            </Procedures>
          XML
        end

        def expected_xml_for_vascular_access
          <<~XML.squish.gsub("> <", "><")
            <Procedures>
              <DialysisSessions start="2021-01-01" stop="2021-02-01"/>
              <VascularAccess>
                <ProcedureType>
                  <CodingStandard>SNOMED</CodingStandard>
                  <Code>TestProcedureCode</Code>
                  <Description>TestProcedureCodeDescription</Description>
                </ProcedureType>
                <ProcedureTime>2021-01-02T00:00:00+00:00</ProcedureTime>
                <Attributes>
                  <ACC19>2021-01-03T00:00:00+00:00</ACC19>
                  <ACC20>2021-01-04T00:00:00+00:00</ACC20>
                  <ACC30>2</ACC30>
                </Attributes>
              </VascularAccess>
            </Procedures>
          XML
        end

        it "renders empty Procedures with an empty DialysisSessions element" do
          patient = build_patient(finished_hd_sessions: [], transplant_operations: [])

          expected_xml = <<~XML.squish.gsub("> <", "><")
            <Procedures>
              <DialysisSessions start="2021-01-01" stop="2021-02-01"/>
            </Procedures>
          XML

          actual_xml = format_xml(described_class.new(patient:).xml)

          expect(actual_xml).to match_xml(expected_xml)
        end

        it "renders DialysisSessions and Transplant procedures" do
          session = build_hd_session
          operation = build_transplant_operation

          patient = build_patient(
            finished_hd_sessions: [session],
            transplant_operations: [operation]
          )

          actual_xml = format_xml(described_class.new(patient:).xml)

          expect(actual_xml).to match_xml(expected_xml_for_session_and_transplant)
        end

        it "renders VascularAccess procedures" do
          access_type = create(
            :access_type,
            rr02_code: "AVF",
            snomed_procedure_code: "TestProcedureCode",
            snomed_procedure_description: "TestProcedureCodeDescription"
          )
          procedure = create(
            :access_procedure,
            type: access_type,
            performed_on: Date.parse("2021-01-02"),
            first_used_on: Date.parse("2021-01-03"),
            failed_on: Date.parse("2021-01-04"),
            pd_catheter_insertion_technique: create(
              :catheter_insertion_technique,
              code: 2,
              description: "Laparoscopic"
            )
          )
          patient = instance_double(
            Renalware::UKRDC::PatientPresenter,
            changes_since:,
            changes_up_until:,
            finished_hd_sessions: [],
            transplant_operations: [],
            access_procedures: [procedure]
          )

          actual_xml = format_xml(described_class.new(patient:).xml)

          expect(actual_xml).to match_xml(expected_xml_for_vascular_access)
        end
      end
    end
  end
end
