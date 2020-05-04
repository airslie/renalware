# frozen_string_literal: true

require "rails_helper"

module Renalware
  module PD
    describe AdequacyCalculatedAttributes do
      describe "#to_h" do
        subject(:hash) { described_class.new(adequacy: adequacy, clinic_visit: visit).to_h }

        let(:visit) { Clinics::ClinicVisit.new }
        let(:adequacy) { AdequacyResult.new }

        context "when no visit is passed" do
          let(:visit) { nil }

          it { is_expected.to eq({}) }
        end

        context "when no adequacy is passed" do
          let(:adequacy) { nil }

          it { is_expected.to eq({}) }
        end

        context "when visit and adequacy are present but there is nothing to calculate" do
          it "returns a hash with nil for each key" do
            is_expected.to eq(
              {
                dietry_protein_intake: nil,
                pertitoneal_creatinine_clearance: nil,
                pertitoneal_ktv: nil,
                renal_creatinine_clearance: nil,
                renal_ktv: nil,
                total_creatinine_clearance: nil,
                total_ktv: nil
              }
            )
          end
        end
      end

      describe "#renal_urine_clearance" do
        subject do
          described_class.new(adequacy: adequacy, clinic_visit: nil).renal_urine_clearance
        end

        let(:adequacy) { AdequacyResult.new(urine_urea: 10, serum_urea: 20, urine_24_vol: 3000) }

        context "when all values are present" do
          it { is_expected.to eq(10.5) }
        end

        context "when urine_24_missing is true" do
          before { adequacy.urine_24_missing = true }

          it { is_expected.to be_nil }
        end

        context "when urine_urea, serum_urea, urine_24_vol are zero or nil" do
          attrs = %i(urine_urea serum_urea urine_24_vol)
          invalid_values = [nil, 0]

          attrs.each do |attr|
            invalid_values.each do |val|
              before { adequacy.public_send(:"#{attr}=", val) }

              it { is_expected.to be_nil }
            end
          end
        end
      end

      describe "#renal_creatinine_clearance" do
        subject do
          described_class.new(adequacy: adequacy, clinic_visit: nil).renal_creatinine_clearance
        end

        let(:adequacy) do
          AdequacyResult.new(urine_creatinine: 10, serum_creatinine: 20, urine_24_vol: 3000)
        end

        context "when all values are present" do
          it { is_expected.to eq(10500.0) }
        end

        context "when urine_24_missing is true" do
          before { adequacy.urine_24_missing = true }

          it { is_expected.to be_nil }
        end

        context "when urine_creatinine, serum_creatinine, urine_24_vol are zero or nil" do
          attrs = %i(urine_creatinine serum_creatinine urine_24_vol)
          invalid_values = [nil, 0]

          attrs.each do |attr|
            invalid_values.each do |val|
              before { adequacy.public_send(:"#{attr}=", val) }

              it { is_expected.to be_nil }
            end
          end
        end
      end

      describe "#residual_renal_function" do
        subject do
          described_class.new(adequacy: adequacy, clinic_visit: visit).residual_renal_function
        end

        let(:adequacy) do
          AdequacyResult.new(
            urine_urea: 10,
            serum_urea: 20,
            urine_creatinine: 30,
            serum_creatinine: 40,
            urine_24_vol: 3000
          )
        end

        let(:visit) do
          Clinics::ClinicVisit.new(body_surface_area: 100)
        end

        context "when all values are present" do
          it { is_expected.to eq(135) }
        end

        context "when body_surface_area is nil" do
          before { visit.body_surface_area = nil }

          it { is_expected.to be_nil }
        end

        context "when body_surface_area is 0" do
          before { visit.body_surface_area = 0 }

          it { is_expected.to be_nil }
        end

        context "when renal_urine_clearance is nil" do
          before { adequacy.urine_24_missing = true }

          it { is_expected.to be_nil }
        end
      end

      describe "#pertitoneal_creatinine_clearance" do
        subject do
          described_class.new(adequacy: adequacy, clinic_visit: visit)
            .pertitoneal_creatinine_clearance
        end

        let(:adequacy) do
          AdequacyResult.new(
            urine_urea: 10,
            serum_urea: 20,
            urine_creatinine: 30,
            serum_creatinine: 40,
            urine_24_vol: 3000,
            dialysate_creatinine: 200,
            dial_24_vol_out: 2000
          )
        end

        let(:visit) do
          Clinics::ClinicVisit.new(body_surface_area: 10)
        end

        context "when all values are present" do
          it { is_expected.to eq(12) }
        end

        context "when body_surface_area is nil" do
          before { visit.body_surface_area = nil }

          it { is_expected.to be_nil }
        end

        context "when body_surface_area is 0" do
          before { visit.body_surface_area = 0 }

          it { is_expected.to be_nil }
        end

        context "when dialysate_creatinine, serum_creatinine, dial_24_vol_out are zero or nil" do
          attrs = %i(dialysate_creatinine serum_creatinine dial_24_vol_out)
          invalid_values = [nil, 0]

          attrs.each do |attr|
            invalid_values.each do |val|
              before { adequacy.public_send(:"#{attr}=", val) }

              it { is_expected.to be_nil }
            end
          end
        end
      end

      describe "#total_creatinine_clearance" do
        context "when residual_renal_function and pertitoneal_creatinine_clearance are present" do
          it "sums them" do
            calcs = described_class.new(adequacy: nil, clinic_visit: nil)
            allow(calcs).to receive(:residual_renal_function).and_return(1)
            allow(calcs).to receive(:pertitoneal_creatinine_clearance).and_return(2)

            expect(calcs.total_creatinine_clearance).to eq(3)
          end
        end

        context "when residual_renal_function is nil" do
          it "returns nil" do
            calcs = described_class.new(adequacy: nil, clinic_visit: nil)
            allow(calcs).to receive(:residual_renal_function).and_return(nil)
            allow(calcs).to receive(:pertitoneal_creatinine_clearance).and_return(2)

            expect(calcs.total_creatinine_clearance).to be_nil
          end
        end

        context "when pertitoneal_creatinine_clearance is nil" do
          it "returns nil" do
            calcs = described_class.new(adequacy: nil, clinic_visit: nil)
            allow(calcs).to receive(:residual_renal_function).and_return(1)
            allow(calcs).to receive(:pertitoneal_creatinine_clearance).and_return(nil)

            expect(calcs.total_creatinine_clearance).to be_nil
          end
        end
      end

      describe "#dietry_protein_intake" do
        subject do
          described_class.new(adequacy: adequacy, clinic_visit: visit).dietry_protein_intake
        end

        let(:adequacy) do
          AdequacyResult.new(
            urine_urea: 10,
            urine_24_vol: 3000,
            dialysate_urea: 200,
            dial_24_vol_out: 2000
          )
        end

        let(:visit) do
          Clinics::ClinicVisit.new(body_surface_area: 10, weight: 100.0)
        end

        context "when required adequacy attributes are present" do
          it { is_expected.to eq(1.36) }
        end

        context "when visit weight is nil" do
          before { visit.weight = nil }

          it { is_expected.to be_nil }
        end

        context "when visit weight is 0" do
          before { visit.weight = 0 }

          it { is_expected.to be_nil }
        end

        context "when required adequacy attributes are zero or nil" do
          attrs = %i(dialysate_urea dial_24_vol_out urine_urea urine_24_vol)
          invalid_values = [nil, 0]

          attrs.each do |attr|
            invalid_values.each do |val|
              before { adequacy.public_send(:"#{attr}=", val) }

              it { is_expected.to be_nil }
            end
          end
        end
      end

      describe "#renal_ktv" do
        subject { described_class.new(adequacy: adequacy, clinic_visit: visit).renal_ktv }

        let(:adequacy) do
          AdequacyResult.new(
            urine_urea: 69,
            urine_24_vol: 1700,
            serum_urea: 16.1
          )
        end

        let(:visit) { Clinics::ClinicVisit.new(total_body_water: 27.0) }

        context "when required values are present" do
          it { is_expected.to eq(1.89) }
        end

        context "when required adequacy values are nil or 0" do
          attrs = %i(urine_urea serum_urea urine_24_vol)
          invalid_values = [nil, 0]

          attrs.each do |attr|
            invalid_values.each do |val|
              before { adequacy.public_send(:"#{attr}=", val) }

              it { is_expected.to be_nil }
            end
          end
        end

        context "when total_body_water is nil" do
          before { visit.total_body_water = nil }

          it { is_expected.to be_nil }
        end

        context "when total_body_water is 0" do
          before { visit.total_body_water = 0 }

          it { is_expected.to be_nil }
        end
      end

      describe "#pertitoneal_ktv" do
        subject { described_class.new(adequacy: adequacy, clinic_visit: visit).pertitoneal_ktv }

        let(:adequacy) do
          AdequacyResult.new(
            serum_urea: 16.1,
            dialysate_urea: 9.7,
            dial_24_vol_out: 8991
          )
        end

        let(:visit) { Clinics::ClinicVisit.new(total_body_water: 27.0) }

        context "when required values are present" do
          it { is_expected.to eq(1.4) }
        end

        context "when required adequacy values are nil or 0" do
          attrs = %i(serum_urea dialysate_urea dial_24_vol_out)
          invalid_values = [nil, 0]

          attrs.each do |attr|
            invalid_values.each do |val|
              before { adequacy.public_send(:"#{attr}=", val) }

              it { is_expected.to be_nil }
            end
          end
        end

        context "when total_body_water is nil" do
          before { visit.total_body_water = nil }

          it { is_expected.to be_nil }
        end

        context "when total_body_water is 0" do
          before { visit.total_body_water = 0 }

          it { is_expected.to be_nil }
        end
      end

      describe "#total_ktv" do
        context "when renal_ktv and pertitoneal_ktv are present" do
          it "sums them" do
            calcs = described_class.new(clinic_visit: nil, adequacy: nil)
            allow(calcs).to receive(:renal_ktv).and_return(1.1)
            allow(calcs).to receive(:pertitoneal_ktv).and_return(2.2)

            expect(calcs.total_ktv).to eq(3.3)
          end
        end

        context "when renal_ktv is nil" do
          it "returns nil" do
            calcs = described_class.new(clinic_visit: nil, adequacy: nil)
            allow(calcs).to receive(:renal_ktv).and_return(nil)
            allow(calcs).to receive(:pertitoneal_ktv).and_return(2.2)

            expect(calcs.total_ktv).to eq(nil)
          end
        end

        context "when pertitoneal_ktv is nil" do
          it "returns nil" do
            calcs = described_class.new(clinic_visit: nil, adequacy: nil)
            allow(calcs).to receive(:renal_ktv).and_return(1.1)
            allow(calcs).to receive(:pertitoneal_ktv).and_return(nil)

            expect(calcs.total_ktv).to eq(nil)
          end
        end
      end
    end
  end
end
