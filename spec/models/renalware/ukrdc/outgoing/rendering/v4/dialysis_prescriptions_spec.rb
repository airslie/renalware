require "builder"

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::V4::DialysisPrescriptions do
        include XmlSpecHelper

        it "renders a DialysisPrescriptions element" do
          travel_to Time.zone.parse("2021-02-01 09:02:02") do
            patient = PatientPresenter.new(
              instance_double(Renalware::Patient, sent_to_ukrdc_at: nil),
              changes_since: "2021-01-01 10:01:01"
            )
            expected_xml = "<DialysisPrescriptions start=\"2021-01-01\" stop=\"2021-02-01\"/>"

            actual_xml = format_xml(described_class.new(patient:).xml)

            expect(actual_xml).to eq(expected_xml)
          end
        end
      end
    end
  end
end
