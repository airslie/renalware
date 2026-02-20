require "builder"

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::V4::DialysisPrescriptions do
        include XmlSpecHelper

        let(:by) { create(:user, :minimal) }
        let(:prescriber) { by }
        let(:hd_patient) do
          create(
            :hd_patient,
            :minimal,
            by:,
            sent_to_ukrdc_at: nil
          )
        end
        let(:accesses_patient) { hd_patient.becomes(Accesses::Patient) }
        let(:schedule_mon_wed_fri_am) { create(:schedule_definition, :mon_wed_fri_am) }
        let(:schedule_tue_sat_pm) { create(:schedule_definition, :tue_sat_pm) }
        let(:access_type) { create(:access_type, rr02_code: "AVF") }

        it "renders a DialysisPrescriptions element" do # rubocop:disable RSpec/ExampleLength
          travel_to Time.zone.parse("2021-02-01 09:02:02") do
            create(:access_profile,
                   patient: accesses_patient,
                   type: access_type,
                   started_on: Time.zone.parse("2021-01-01 11:01:01"))

            patient = PatientPresenter.new(
              hd_patient,
              changes_since: "2021-01-01 10:01:01"
            )

            _profile_prev = HD::Profile.create!(
              patient: hd_patient,
              by:,
              prescribed_on: Time.zone.parse("2021-01-10 09:02:02"),
              deactivated_at: Time.zone.parse("2021-01-12 09:02:02"), # previous
              schedule_definition: schedule_mon_wed_fri_am,
              prescribed_time: 4 * 60, # 4 hours in minutes
              active: false,
              prescriber:,
              created_at: Time.zone.parse("2021-01-09 00:00:01")
            )
            _profile_curr = HD::Profile.create!(
              patient: hd_patient,
              by:,
              prescribed_on: Time.zone.parse("2021-01-12 09:02:02"),
              deactivated_at: nil, # current
              schedule_definition: schedule_tue_sat_pm,
              prescribed_time: (4 * 60) + 30, # 4.5 hours in minutes
              active: true,
              prescriber:,
              created_at: Time.zone.parse("2021-01-11 00:00:01")
            )
            expected_xml = <<~XML.squish.gsub("> <", "><")
              <DialysisPrescriptions start=\"2021-01-01\" stop=\"2021-02-01\">
                <DialysisPrescription>
                  <EnteredOn>2021-01-09</EnteredOn>
                  <FromTime>2021-01-10</FromTime>
                  <ToTime>2021-01-12</ToTime>
                  <SessionType>HD</SessionType>
                  <SessionsPerWeek>3</SessionsPerWeek>
                  <TimeDialysed>4:00</TimeDialysed>
                  <VascularAccess>AVF</VascularAccess>
                </DialysisPrescription>
                <DialysisPrescription>
                  <EnteredOn>2021-01-11</EnteredOn>
                  <FromTime>2021-01-12</FromTime>
                  <ToTime></ToTime>
                  <SessionType>HD</SessionType>
                  <SessionsPerWeek>2</SessionsPerWeek>
                  <TimeDialysed>4:30</TimeDialysed>
                  <VascularAccess>AVF</VascularAccess>
                </DialysisPrescription>
              </DialysisPrescriptions>
            XML

            actual_xml = format_xml(described_class.new(patient:).xml)

            expect(actual_xml).to match_xml(expected_xml)
          end
        end
      end
    end
  end
end
