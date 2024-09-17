# frozen_string_literal: true

module Renalware
  module PD
    module APD
      describe NonTidalRegimeCalculations do
        subject { described_class.new(regime) }

        let(:regime) do
          reg = build(:apd_regime, no_cycles_per_apd: 7, fill_volume: 1500)
          reg.bags << build(:pd_regime_bag, role: :ordinary)
          reg
        end
        let(:regime_overnight_volume) { 7 * 1500 }

        describe "#calculated_overnight_volume" do
          it "returns 0 if fill_volume is zero" do
            regime.fill_volume = 0
            expect(described_class.new(regime).calculated_overnight_volume).to be_nil
          end

          it "returns 0 if no_cycles_per_apd is nil" do
            regime.cycles = nil
            expect(described_class.new(regime).calculated_overnight_volume).to be_nil
          end

          it "returns the number of exchanges (cycles) * volume of each exchange (fill_volume)" do
            overnight_volume = described_class.new(regime).calculated_overnight_volume

            expect(overnight_volume).to eq(regime_overnight_volume)
            expect(overnight_volume).to be_a(Integer)
            expect(regime).not_to be_tidal
          end
        end
      end
    end
  end
end
