# frozen_string_literal: true

module Renalware
  module PD
    describe PETResult do
      it_behaves_like "an Accountable model"

      it :aggregate_failures do
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to validate_presence_of(:test_type)
        is_expected.to validate_presence_of(:performed_on)
      end

      describe "calculated fields" do
        describe "calculated_d_pcr" do
          subject do
            described_class.new(
              sample_4hr_creatinine: sample_4hr_creatinine,
              serum_creatinine: serum_creatinine
            ).calculated_d_pcr
          end

          let(:sample_4hr_creatinine) { 100 }
          let(:serum_creatinine) { 10 }

          context "when sample_4hr_creatinine is 0" do
            let(:sample_4hr_creatinine) { 0 }

            it { is_expected.to be_nil }
          end

          context "when sample_4hr_creatinine is nil" do
            let(:sample_4hr_creatinine) { nil }

            it { is_expected.to be_nil }
          end

          context "when serum_creatinine is 0" do
            let(:serum_creatinine) { 0 }

            it { is_expected.to be_nil }
          end

          context "when serum_creatinine is nil" do
            let(:serum_creatinine) { nil }

            it { is_expected.to be_nil }
          end

          context "when both inputs are present" do
            let(:sample_4hr_creatinine) { 100.055 }
            let(:serum_creatinine) { 10.0 }

            it { is_expected.to eq(10.01) }
          end
        end
      end

      describe "calculated_net_uf" do
        subject do
          described_class.new(
            volume_in: volume_in,
            volume_out: volume_out
          ).calculated_net_uf
        end

        let(:volume_in) { 100 }
        let(:volume_out) { 110 }

        context "when volume_in is 0" do
          let(:volume_in) { 0 }

          it { is_expected.to be_nil }
        end

        context "when volume_in is nil" do
          let(:volume_in) { nil }

          it { is_expected.to be_nil }
        end

        context "when volume_out is 0" do
          let(:volume_out) { 0 }

          it { is_expected.to be_nil }
        end

        context "when volume_out is nil" do
          let(:volume_out) { nil }

          it { is_expected.to be_nil }
        end

        context "when both inputs are present" do
          let(:volume_in) { 100 }
          let(:volume_out) { 111 }

          it { is_expected.to eq(11) }
        end
      end
    end
  end
end
