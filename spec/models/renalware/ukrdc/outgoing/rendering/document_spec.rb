# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::Document do
        include LettersSpecHelper
        include XmlSpecHelper

        let(:user) { create(:user, username: "u", family_name: "F", given_name: "G") }
        let(:uk) { create(:united_kingdom) }
        let(:english) { create(:language, :english) }
        let(:white_british) { create(:ethnicity, :white_british) }
        let(:patient) do
          create(
            :patient,
            family_name: "JONES",
            ethnicity: white_british,
            country_of_birth: uk,
            language: english,
            by: user,
            sent_to_ukrdc_at: 1.year.ago,
            send_to_rpv: true,
            practice: create(:practice),
            primary_care_physician: create(:primary_care_physician)
          )
        end

        def create_a_letter
          Renalware::Letters::LetterPresenter.new(
            create_letter(
              to: :patient,
              state: :approved,
              by: user,
              patient: Renalware::Letters.cast_patient(patient),
              description: "xxx",
              approved_at: Date.parse("2019-01-01")
            )
          )
        end

        it do
          create(:hospital_unit, unit_code: "KCH", renal_registry_code: "123")
          renderer = double(call: "xxx") # rubocop:disable RSpec/VerifiedDoubles
          allow(Renalware::Letters::RendererFactory).to receive(:renderer_for).and_return(renderer)
          expected_stream = Base64.encode64("xxx")
          letter = create_a_letter
          expected_xml = <<~XML.squish.gsub("> <", "><")
            <Document>
              <DocumentTime>2019-01-01T00:00:00+00:00</DocumentTime>
              <Clinician>
                <CodingStandard>LOCAL</CodingStandard>
                <Code>u</Code>
                <Description>F, G</Description>
              </Clinician>
              <DocumentName>JONES-#{patient.local_patient_id}-#{letter.id}.pdf</DocumentName>
              <Status>
                <Code>ACTIVE</Code>
              </Status>
              <EnteredBy>
                <CodingStandard>LOCAL</CodingStandard>
                <Code>u</Code>
                <Description>F, G</Description>
              </EnteredBy>
              <EnteredAt>
                <CodingStandard>LOCAL</CodingStandard>
                <Code>123</Code>
              </EnteredAt>
              <FileType>application/pdf</FileType>
              <FileName>JONES-#{patient.local_patient_id}-#{letter.id}.pdf</FileName>
              <Stream>#{expected_stream}</Stream>
            </Document>
          XML

          xml = format_xml(described_class.new(letter: letter).xml)

          expect(xml).to eq(expected_xml)
        end
      end
    end
  end
end
