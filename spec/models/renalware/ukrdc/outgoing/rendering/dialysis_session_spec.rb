# frozen_string_literal: true

require "rails_helper"
require "builder"

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::DialysisSession do
        include XmlSpecHelper

        context "when the blood_flow is not a number" do
          it "leaves unset it '' or null" do
            session = Renalware::HD::Session::Closed.new(performed_on: "2018-11-01")
            session.document.dialysis.blood_flow = ""
            presenter = Renalware::HD::SessionPresenter.new(session)

            actual_xml = format_xml(described_class.new(session: presenter).xml)

            expect(actual_xml).to match("<QHD30/>")
          end

          it "coerces it into an integer if possible" do
            session = Renalware::HD::Session::Closed.new(performed_on: "2018-11-01")
            session.document.dialysis.blood_flow = "101 approx"
            presenter = Renalware::HD::SessionPresenter.new(session)

            actual_xml = format_xml(described_class.new(session: presenter).xml)

            expect(actual_xml).to match("<QHD30>101</QHD30>")
          end

          it "otherwise leaves it as empty" do
            session = Renalware::HD::Session::Closed.new(performed_on: "2018-11-01")
            session.document.dialysis.blood_flow = "n/a"
            presenter = Renalware::HD::SessionPresenter.new(session)

            actual_xml = format_xml(described_class.new(session: presenter).xml)

            expect(actual_xml).to match("<QHD30/>")
          end
        end

        # rubocop:disable RSpec/ExampleLength
        it "renders a DialysisSession element" do
          dialysate = build_stubbed(:hd_dialysate, sodium_content: 100)
          session = Renalware::HD::Session::Closed.new(
            performed_on: "2018-11-01",
            start_time: "11:00",
            end_time: "13:00",
            duration: 123,
            dialysate: dialysate,
            updated_by: build_stubbed(:user, family_name: "F", given_name: "G", username: "U"),
            hospital_unit: build_stubbed(:hospital_unit, unit_code: "U")
          )
          session.document.dialysis.blood_flow = 99
          allow(session).to receive(:uuid).and_return("UUID")
          presenter = Renalware::HD::SessionPresenter.new(session)
          allow(presenter).to receive(:access_rr02_code).and_return("RR02")
          allow(presenter).to receive(:access_rr41_code).and_return("RR41")

          expected_xml = <<~XML.squish.gsub("> <", "><")
            <DialysisSession start="2018-11-01" stop="2018-11-01">
              <ProcedureType>
                <CodingStandard>SNOMED</CodingStandard>
                <Code>302497006</Code>
                <Description>Haemodialysis</Description>
              </ProcedureType>
              <Clinician>
                <Description>F, G</Description>
              </Clinician>
              <ProcedureTime>2018-11-01T11:00:00+00:00</ProcedureTime>
              <EnteredBy>
                <CodingStandard>LOCAL</CodingStandard>
                <Code>U</Code>
                <Description>F, G</Description>
              </EnteredBy>
              <EnteredAt>
                <Code>RJZ</Code>
              </EnteredAt>
              <ExternalId>UUID</ExternalId>
              <Attributes>
                <QHD19>N</QHD19>
                <QHD20>RR02</QHD20>
                <QHD21>RR41</QHD21>
                <QHD22>N</QHD22>
                <QHD30>99</QHD30>
                <QHD31>123</QHD31>
                <QHD32>100</QHD32>
                <QHD33/>
              </Attributes>
            </DialysisSession>
          XML

          actual_xml = format_xml(described_class.new(session: presenter).xml)

          expect(actual_xml).to eq(expected_xml)
        end
        # rubocop:enable RSpec/ExampleLength
      end
    end
  end
end

# TODO: add thee tests from the old builder view spec
#
# describe "#QHD19 (Symptomatic hypotension)" do
#   context "when had_intradialytic_hypotension is yes" do
#     before { session.document.complications.had_intradialytic_hypotension = :yes }

#     it { is_expected.to include("<QHD19>Y</QHD19>") }
#   end

#   context "when had_intradialytic_hypotension is no" do
#     before { session.document.complications.had_intradialytic_hypotension = :no }

#     it { is_expected.to include("<QHD19>N</QHD19>") }
#   end

#   context "when had_intradialytic_hypotension is nil" do
#     before { session.document.complications.had_intradialytic_hypotension = nil }

#     it { is_expected.to include("<QHD19>N</QHD19>") }
#   end
# end

# describe "QHD30 (Blood Flow Rate)" do
#   before { session.document.dialysis.blood_flow = "123" }

#   it { is_expected.to include("<QHD30>123</QHD30>") }
# end

# describe "QHD31 (Time Dialysed in Minutes)" do
#   before {
#     session.start_time = "11:00"
#     session.end_time = "13:01"
#     session.compute_duration
#   }

#   it { is_expected.to include("<QHD31>121</QHD31>") }
# end

# describe "QHD32 (Sodium in Dialysate)" do
#   before {
#     dialysate = build_stubbed(:hd_dialysate, sodium_content: 13)
#     session.dialysate = dialysate
#   }

#   it { is_expected.to include("<QHD32>13</QHD32>") }
# end

# describe "QHD20 (Vascular Access Used)" do
#   before {
#     # Eg when
#     # rr02_code { "TLN" }
#     # rr41_code { "LS" }
#     # however we only want the rr02_code but both are stored concatenated together
#     # in access_type_abbreviation.
#     session.document.info.access_type_abbreviation = "TLN LS"
#   }

#   it { is_expected.to include("<QHD20>TLN</QHD20>") }
# end

# describe "QHD21 (Vascular Access Site) RR41" do
#   before {
#     session.document.info.access_type_abbreviation = "TLN LS"
#   }

#   it { is_expected.to include("<QHD21>LS</QHD21>") }
# end
