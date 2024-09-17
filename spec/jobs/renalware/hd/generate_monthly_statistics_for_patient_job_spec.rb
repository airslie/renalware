# frozen_string_literal: true

module Renalware
  module HD
    describe GenerateMonthlyStatisticsForPatientJob do
      subject(:job) { described_class.new }

      let(:patient) { build_stubbed(:hd_patient) }
      let(:month) { 12 }
      let(:year) { 2016 }

      it { is_expected.to respond_to(:queue_name) }

      describe "#perform" do
        it "delegates to a service object passing in last month" do
          expect_any_instance_of(GenerateMonthlyStatisticsForPatient)
            .to receive(:call).exactly(:once)

          job.perform(patient: patient, month: month, year: year)
        end
      end
    end
  end
end
