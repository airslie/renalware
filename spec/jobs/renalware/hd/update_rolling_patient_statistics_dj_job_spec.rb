# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe UpdateRollingPatientStatisticsDjJob do
      subject(:job) { described_class.new(patient.id) }

      let(:patient) { create(:patient) }

      it { is_expected.to respond_to(:queue_name) }

      describe "#perform" do
        it "delegates to a service object" do
          expect_any_instance_of(UpdateRollingPatientStatistics).to receive(:call)
          job.perform
        end
      end

      describe "#max_attempts" do
        subject { job.max_attempts }

        it { is_expected.to eq(2) }
      end

      describe "#destroy_failed_jobs?" do
        subject { job.destroy_failed_jobs? }

        it { is_expected.to be(true) }
      end

      describe "#def reschedule_at?" do
        subject { job.reschedule_at(time, 1) }

        let(:time) { Time.zone.now }

        it { is_expected.to eq(time + 1.hour) }
      end
    end
  end
end
