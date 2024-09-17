# frozen_string_literal: true

module Renalware
  module PD
    describe AdequacyCalculatedAttributes do
      describe "#to_h" do
        subject(:hash) { described_class.new(adequacy: adequacy, age: 50, sex: "F").to_h }

        let(:adequacy) { AdequacyResult.new }

        context "when no adequacy is passed" do
          let(:adequacy) { nil }

          it { is_expected.to eq({}) }
        end

        context "when adequacy is supplied but there is nothing to calculate" do
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
          described_class.new(adequacy: adequacy, age: 50, sex: "F").renal_urine_clearance
        end

        let(:adequacy) { AdequacyResult.new(urine_urea: 10, serum_urea: 20, urine_24_vol: 3000) }

        context "when urine_24_vol is 0 (anuric)" do
          before { adequacy.urine_24_vol = 0 }

          it { is_expected.to eq(0.0) }
        end

        context "when all values are present" do
          it { is_expected.to eq(10.5) }
        end

        context "when urine_24_missing is true" do
          before { adequacy.urine_24_missing = true }

          it { is_expected.to be_nil }
        end

        context "when urine_urea, serum_urea, urine_24_vol are zero or nil" do
          attrs = %i(urine_urea serum_urea)
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
          described_class.new(adequacy: adequacy, age: 50, sex: "F").renal_creatinine_clearance
        end

        let(:adequacy) do
          AdequacyResult.new(urine_creatinine: 10, serum_creatinine: 20, urine_24_vol: 3000)
        end

        context "when all values are present" do
          it { is_expected.to eq(10500.0) }
        end

        context "when urine_24_vol is 0 (anuric)" do
          before { adequacy.urine_24_vol = 0 }

          it { is_expected.to eq(0.0) }
        end

        context "when urine_24_missing is true" do
          before { adequacy.urine_24_missing = true }

          it { is_expected.to be_nil }
        end

        context "when urine_creatinine, serum_creatinine, urine_24_vol are zero or nil" do
          attrs = %i(urine_creatinine serum_creatinine)
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
          described_class.new(adequacy: adequacy, age: 50, sex: "F").residual_renal_function
        end

        let(:height) { 1.23 }
        let(:adequacy) do
          AdequacyResult.new(
            urine_urea: 10,
            serum_urea: 20,
            urine_creatinine: 30,
            serum_creatinine: 40,
            urine_24_vol: 3000,
            height: height,
            weight: 100.99 # body_surface_area will eq 47.14
          )
        end

        context "when urine_24_vol is 0 (anuric)" do
          before { adequacy.urine_24_vol = 0 }

          it { is_expected.to eq(0.0) }
        end

        context "when all values are present" do
          it { is_expected.to eq(8116) }
        end

        context "when height is nil" do
          let(:height) { nil }

          it { is_expected.to be_nil }
        end

        context "when height is 0" do
          let(:height) { 0 }

          it { is_expected.to be_nil }
        end

        context "when renal_urine_clearance is nil" do
          before { adequacy.urine_24_missing = true }

          it { is_expected.to be_nil }
        end
      end

      describe "#pertitoneal_creatinine_clearance" do
        subject do
          described_class.new(
            adequacy: adequacy,
            age: 50,
            sex: "F"
          ).pertitoneal_creatinine_clearance
        end

        let(:height) { 1.23 }
        let(:adequacy) do
          AdequacyResult.new(
            urine_urea: 10,
            serum_urea: 20,
            urine_creatinine: 30,
            serum_creatinine: 40,
            urine_24_vol: 3000,
            dialysate_creatinine: 200,
            dial_24_vol_out: 2000,
            height: height,
            weight: 100.99
          )
        end

        context "when all values are present" do
          it { is_expected.to eq(72) }
        end

        context "when height is nil" do
          let(:height) { nil }

          it { is_expected.to be_nil }
        end

        context "when body_surface_area is 0" do
          let(:height) { 0 }

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
            calcs = described_class.new(adequacy: nil, age: 50, sex: "F")
            allow(calcs).to receive_messages(
              residual_renal_function: 1,
              pertitoneal_creatinine_clearance: 2
            )

            expect(calcs.total_creatinine_clearance).to eq(3)
          end
        end

        context "when residual_renal_function is nil" do
          it "returns nil" do
            calcs = described_class.new(adequacy: nil, age: 50, sex: "F")
            allow(calcs).to receive_messages(
              residual_renal_function: nil,
              pertitoneal_creatinine_clearance: 2
            )

            expect(calcs.total_creatinine_clearance).to be_nil
          end
        end

        context "when pertitoneal_creatinine_clearance is nil" do
          it "returns nil" do
            calcs = described_class.new(adequacy: nil, age: 50, sex: "F")
            allow(calcs).to receive_messages(
              residual_renal_function: 1,
              pertitoneal_creatinine_clearance: nil
            )

            expect(calcs.total_creatinine_clearance).to be_nil
          end
        end
      end

      describe "#dietry_protein_intake" do
        subject do
          described_class.new(adequacy: adequacy, age: 50, sex: "F").dietry_protein_intake
        end

        let(:weight) { 100.99 }
        let(:adequacy) do
          AdequacyResult.new(
            urine_urea: 10,
            urine_24_vol: 3000,
            dialysate_urea: 200,
            dial_24_vol_out: 2000,
            height: 1.23,
            weight: weight
          )
        end

        context "when required adequacy attributes are present" do
          it { is_expected.to eq(1.35) }
        end

        context "when visit weight is nil" do
          let(:weight) { nil }

          it { is_expected.to be_nil }
        end

        context "when visit weight is 0" do
          let(:weight) { 0 }

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
        subject { described_class.new(adequacy: adequacy, age: 50, sex: "F").renal_ktv }

        let(:weight) { 100.99 }
        let(:adequacy) do
          AdequacyResult.new(
            urine_urea: 69,
            urine_24_vol: 1700,
            serum_urea: 16.1,
            height: 1.23,
            weight: weight
          )
        end

        context "when required values are present" do
          it { is_expected.to eq(1.42) }
        end

        context "when urine_24_vol is 0 (anuric)" do
          before { adequacy.urine_24_vol = 0 }

          it { is_expected.to eq(0.0) }
        end

        context "when required adequacy values are nil or 0" do
          attrs = %i(urine_urea serum_urea)
          invalid_values = [nil, 0]

          attrs.each do |attr|
            invalid_values.each do |val|
              before { adequacy.public_send(:"#{attr}=", val) }

              it { is_expected.to be_nil }
            end
          end
        end

        context "when total_body_water is nil" do
          let(:weight) { nil }

          it { is_expected.to be_nil }
        end

        context "when total_body_water is 0" do
          let(:weight) { 0 }

          it { is_expected.to be_nil }
        end
      end

      describe "#pertitoneal_ktv" do
        subject { described_class.new(adequacy: adequacy, age: 50, sex: "F").pertitoneal_ktv }

        let(:weight) { 100.99 }
        let(:adequacy) do
          AdequacyResult.new(
            serum_urea: 16.1,
            dialysate_urea: 9.7,
            dial_24_vol_out: 8991,
            weight: weight,
            height: 1.23
          )
        end

        context "when required values are present" do
          it { is_expected.to eq(1.05) }
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
          let(:weight) { nil }

          it { is_expected.to be_nil }
        end

        context "when total_body_water is 0" do
          let(:weight) { 0 }

          it { is_expected.to be_nil }
        end
      end

      describe "#total_ktv" do
        context "when renal_ktv and pertitoneal_ktv are present" do
          it "sums them" do
            calcs = described_class.new(adequacy: nil, age: 50, sex: "F")
            allow(calcs).to receive_messages(renal_ktv: 1.1, pertitoneal_ktv: 2.2)

            expect(calcs.total_ktv).to eq(3.3)
          end
        end

        context "when renal_ktv is nil" do
          it "returns nil" do
            calcs = described_class.new(adequacy: nil, age: 50, sex: "F")
            allow(calcs).to receive_messages(renal_ktv: nil, pertitoneal_ktv: 2.2)

            expect(calcs.total_ktv).to be_nil
          end
        end

        context "when pertitoneal_ktv is nil" do
          it "returns nil" do
            calcs = described_class.new(adequacy: nil, age: 50, sex: "F")
            allow(calcs).to receive_messages(renal_ktv: 1.1, pertitoneal_ktv: nil)

            expect(calcs.total_ktv).to be_nil
          end
        end
      end
    end
  end
end
