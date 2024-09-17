# frozen_string_literal: true

module Renalware
  module Patients
    describe CalculateAge do
      subject { described_class.for(patient) }

      let(:patient) { Patient.new(died_on: died_on, born_on: born_on) }
      let(:born_on) { nil }
      let(:died_on) { nil }
      let(:today) { Time.zone.now.utc.to_date }

      describe "#for" do
        context "when the patient has no born_on date" do
          let(:born_on) { nil }

          it { is_expected.to be_nil }
        end

        context "when the patient is alive" do
          let(:died_on) { nil }

          context "when the patients date of birth is < 1 year ago" do
            let(:born_on) { 1.day.ago }

            it { is_expected.to eq(0) }
          end

          context "when the patients is 1yr old yesterday" do
            let(:born_on) { today - 1.year - 1.day }

            it { is_expected.to eq(1) }
          end

          context "when the patients is 1yr old tomorrow" do
            let(:born_on) { today - 1.year + 1.day }

            it { is_expected.to eq(0) }
          end

          context "when the patients date of birth is 100 years ago yesterday" do
            let(:born_on) { today - 100.years - 1.day }

            it { is_expected.to eq(100) }
          end

          context "when the patients date of birth is 100 years tomorrow" do
            let(:born_on) { today - 100.years + 1.day }

            it { is_expected.to eq(99) }
          end
        end

        context "when the patient is has a died_on date" do
          context "when the patient has no born_on date" do
            let(:born_on) { nil }
            let(:died_on) { 1.year.ago }

            it { is_expected.to be_nil }
          end

          context "when the patient has born 100 years today ago and died exactly 10 years later" do
            let(:born_on) { Date.parse("1900-02-01") }
            let(:died_on) { Date.parse("2000-02-01") }

            it { is_expected.to eq(100) }
          end

          context "when the patient has born 100 years ago and died 10 years and 1 day later" do
            let(:born_on) { Date.parse("1900-02-01") }
            let(:died_on) { Date.parse("2000-02-02") }

            it { is_expected.to eq(100) }
          end

          context "when patient born 100 years ago and died 1 day short of 10 years later" do
            let(:born_on) { Date.parse("1900-02-01") }
            let(:died_on) { Date.parse("2000-01-31") }

            it { is_expected.to eq(99) }
          end
        end
      end
    end
  end
end
