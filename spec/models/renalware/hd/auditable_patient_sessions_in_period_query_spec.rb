# frozen_string_literal: true

module Renalware
  module HD
    module Sessions
      describe AuditablePatientSessionsInPeriodQuery do
        subject(:query) { described_class.new(patient: patient, period: period) }

        let(:patient) { create(:hd_patient) }
        let(:another_patient) { create(:hd_patient) }
        let(:period) { MonthPeriod.new(month: month, year: year) }
        let(:month) { 12 }
        let(:year) { 2016 }

        it "selects closed and dna sessions within the requested month" do
          # This Nov one is too early
          november_session = travel_to Time.zone.parse("2016-11-30 22:00:00") do
            create(:hd_closed_session, patient: patient, signed_off_at: Time.zone.now)
          end

          # These Dec ones are OK...
          travel_to Time.zone.parse("2016-12-01 00:00:00") do
            create(:hd_closed_session, patient: patient, signed_off_at: Time.zone.now)
            create(:hd_dna_session, patient: patient, started_at: Time.zone.now)
            # .. except this one as its not signed off yet
            create(:hd_open_session, patient: patient, started_at: Time.zone.now)
            # .. and this one as it belongs to another patient
            create(:hd_open_session, patient: another_patient, started_at: Time.zone.now)
          end

          # ..so are these Dec ones
          travel_to Time.zone.parse("2016-12-31 22:00:00") do
            create(:hd_closed_session, patient: patient, signed_off_at: Time.zone.now)
            create(:hd_dna_session, patient: patient, started_at: Time.zone.now)
          end

          # ..but this Jan one is too late
          january_session = travel_to Time.zone.parse("2017-01-01 00:01:00") do
            create(:hd_closed_session, patient: patient, signed_off_at: Time.zone.now)
          end

          # query#call yields for each hd patient, passing their sessions also
          sessions = query.call

          expect(sessions.count).to eq(4)
          expect(sessions).not_to include(november_session)
          expect(sessions).not_to include(january_session)
        end
      end
    end
  end
end
