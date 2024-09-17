# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::CauseOfDeath do
        include XmlSpecHelper

        def patient_presenter(deceased:, add_cause:)
          cause = Deaths::Cause.new(code: 1, created_at: Time.zone.parse("2019-01-01")) if add_cause
          patient = instance_double(Renalware::Patient, first_cause: cause, sent_to_ukrdc_at: nil)
          presenter = UKRDC::PatientPresenter.new(patient)
          allow(presenter).to receive(:dead?).and_return(deceased)
          presenter
        end

        context "when the patient is deceased and has a first cause of death" do
          it "renders a CauseOfDeath element" do
            patient = patient_presenter(deceased: true, add_cause: true)

            expected_xml = <<~XML.squish.gsub("> <", "><")
              <CauseOfDeath>
                <DiagnosisType>final</DiagnosisType>
                <Diagnosis>
                  <CodingStandard>EDTA_COD</CodingStandard>
                  <Code>1</Code>
                </Diagnosis>
                <EnteredOn>2019-01-01T00:00:00+00:00</EnteredOn>
              </CauseOfDeath>
            XML

            xml = format_xml(described_class.new(patient: patient).xml)

            expect(xml).to eq(expected_xml)
          end
        end

        context "when the patient is deceased but has no first cause of death" do
          it "renders nothing" do
            patient = patient_presenter(deceased: true, add_cause: false)

            expect(described_class.new(patient: patient).xml).to be_nil
          end
        end

        context "when the patient is not deceased" do
          it "renders nothing" do
            patient = patient_presenter(deceased: false, add_cause: false)

            expect(described_class.new(patient: patient).xml).to be_nil
          end
        end
      end
    end
  end
end
