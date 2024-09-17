# frozen_string_literal: true

module Renalware
  module HD
    describe UpdateRollingPatientStatisticsJob do
      subject(:job) { described_class }

      let(:patient) { Patient.new }

      let(:rolling_patient_statistics_instance) {
        instance_double(UpdateRollingPatientStatistics, call: nil)
      }

      it { is_expected.to respond_to(:queue_name) }

      describe "#perform" do
        before do
          allow(UpdateRollingPatientStatistics).to receive(:new)
            .with(patient: kind_of(Patient))
            .and_return(rolling_patient_statistics_instance)
        end

        it "delegates to a service object" do
          job.perform_now(patient)

          expect(rolling_patient_statistics_instance).to have_received(:call)
        end
      end

      describe "#queue_name" do
        subject { job.queue_name }

        it { is_expected.to eq "hd_patient_statistics" }
      end
    end
  end
end
