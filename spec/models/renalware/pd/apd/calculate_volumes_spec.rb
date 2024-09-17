# frozen_string_literal: true

module Renalware
  module PD
    module APD
      describe CalculateVolumes do
        let(:patient) { build_stubbed(:pd_patient) }

        describe "#call" do
          it "uses non tidal calculations when the regime is not tidal" do
            expect_any_instance_of(NonTidalRegimeCalculations)
              .to receive(:calculated_overnight_volume)
              .at_least(:once)
              .and_return(100)
            regime = build(:apd_regime, tidal_indicator: false)

            described_class.new(regime).call

            expect(regime.overnight_volume).to eq(100)
          end

          it "uses tidal calculations when the regime is tidal" do
            expect_any_instance_of(TidalRegimeCalculations)
              .to receive(:calculated_overnight_volume)
              .at_least(:once)
              .and_return(100)
            regime = build(:apd_regime, tidal_indicator: true)

            described_class.new(regime).call

            expect(regime.overnight_volume).to eq(100)
          end
        end
      end
    end
  end
end
