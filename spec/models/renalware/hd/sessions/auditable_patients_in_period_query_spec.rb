module Renalware
  module HD
    module Sessions
      describe AuditablePatientsInPeriodQuery do
        subject(:query) { described_class.new(period: period) }

        let(:patient1) { create(:hd_patient) }
        let(:patient2) { create(:hd_patient) }
        let(:patient3) { create(:hd_patient) }
        let(:period) { MonthPeriod.new(month: month, year: year) }
        let(:month) { 12 }
        let(:year) { 2016 }

        it "returns only those patients having finished sessions in the specific period" do
          # patient1 has a session outside the period so he won't be returned
          travel_to Time.zone.parse("2016-11-30 22:00:00") do
            create(:hd_closed_session, patient: patient1, signed_off_at: Time.zone.now)
          end

          # patient2 will be returned as she has an closed session in the period
          travel_to Time.zone.parse("2016-12-01 01:00:01") do
            create(:hd_closed_session, patient: patient2, signed_off_at: Time.zone.now)
          end

          # patient3 has a session outside the period so won't be returned
          travel_to Time.zone.parse("2017-01-01 00:01:01") do
            create(:hd_closed_session, patient: patient3, signed_off_at: Time.zone.now)
          end

          patients = query.call

          expect(patients).to eq [patient2]
        end
      end
    end
  end
end
