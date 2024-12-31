module Renalware
  module HD
    describe GenerateMonthlyStatistics, type: :service do
      subject(:service) { described_class.new }

      it { is_expected.to respond_to(:queue_name) }

      describe "period" do
        context "when no month or year supplied" do
          subject(:period) { described_class.new.period }

          it "defaults to operating on month/year of the previous month" do
            travel_to Date.parse("2013/01/31") do
              expect(period).to have_attributes(month: 12, year: 2012)
            end
          end
        end

        context "when only a month is supplied as a named argument" do
          subject(:period) { described_class.new(month: 5).period }

          it "raises an error because year must also be supplied" do
            expect { period }.to raise_error(ArgumentError)
          end
        end

        context "when only a year is supplied as a named argument" do
          subject(:period) { described_class.new(year: 2016).period }

          it "raises an error because month must also be supplied" do
            expect { period }.to raise_error(ArgumentError)
          end
        end

        context "when month and year supplied as named arguments" do
          subject(:period) { described_class.new(month: 5, year: 2016).period }

          it "uses the correct month and year" do
            expect(period).to have_attributes(month: 5, year: 2016)
          end
        end
      end

      describe "#call" do
        context "when initialized with not arguments" do
          it "enqueues a job per patient (that spawned job will actually generate the stats)" do
            patient = create(:hd_patient)

            travel_to Date.new(2017, 01, 31) do
              create(:hd_closed_session, patient: patient, signed_off_at: 1.month.ago)

              allow(GenerateMonthlyStatisticsForPatientJob).to receive(:perform_later)

              service.call

              expect(GenerateMonthlyStatisticsForPatientJob).to have_received(:perform_later)
                .exactly(:once)
                .with(
                  patient: patient,
                  month: 12,
                  year: 2016
                )
            end
          end
        end

        context "when initialized with a year and month" do
          subject(:service) { described_class.new(year: 2018, month: 1) }

          it "enqueues a job per patient (that spawned job will actually generate the stats)" do
            patient_a = create(:hd_patient)
            patient_b = create(:hd_patient)

            create(:hd_closed_session, patient: patient_a, signed_off_at: Date.parse("2018-01-31"))
            create(:hd_closed_session, patient: patient_b, signed_off_at: Date.parse("2018-02-28"))

            allow(GenerateMonthlyStatisticsForPatientJob).to receive(:perform_later)

            service.call

            expect(GenerateMonthlyStatisticsForPatientJob).to have_received(:perform_later)
              .exactly(:once)
              .with(
                patient: patient_a,
                month: 1,
                year: 2018
              )
          end
        end
      end
    end
  end
end
