# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::Observation do
        include XmlSpecHelper

        it do
          expected_xml = <<~XML.squish.gsub("> <", "><")
            <Observation>
              <ObservationTime>2019-01-01T00:00:01+00:00</ObservationTime>
              <ObservationCode>
                <CodingStandard>UKRR</CodingStandard>
                <Code>QBLG3</Code>
                <Description>Blood pressure device Cuff pressure.systolic</Description>
              </ObservationCode>
              <ObservationValue>1.1</ObservationValue>
              <ObservationUnits>mmHg</ObservationUnits>
              <Clinician>
                <Description>F, G</Description>
              </Clinician>
            </Observation>
          XML

          actual_xml = format_xml(
            described_class.new(
              observed_at: Time.zone.parse("2019-01-01 00:00:01"),
              measurement: 1.1,
              i18n_key: "blood_pressure.systolic",
              updated_by: User.new(family_name: "F", given_name: "G")
            ).xml
          )

          expect(actual_xml).to eq(expected_xml)
        end
      end
    end
  end
end
