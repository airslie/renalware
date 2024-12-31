module Renalware
  module PD
    module APD
      describe TidalRegimeCalculations do
        describe "#overnight_volume" do
          context "when there are 9 cycles (exchanges), a 1500ml fill volume and 80% tidal" do
            let(:regime) do
              build(:apd_regime,
                    no_cycles_per_apd: 9,
                    tidal_indicator: true,
                    tidal_percentage: 80,
                    fill_volume: 1500)
            end

            it "raises an error if the regime is not tidal" do
              regime.tidal_indicator = false
              expect {
                described_class.new(regime).calculated_overnight_volume
              }.to raise_error(ArgumentError)
            end

            it "returns 0 if cycles is nil" do
              regime.cycles = nil
              expect(described_class.new(regime).calculated_overnight_volume).to be_nil
            end

            it "returns 0 if fill volume is zero" do
              regime.fill_volume = 0
              expect(described_class.new(regime).calculated_overnight_volume).to be_nil
            end

            it "returns 0 if tidal percentage is 0" do
              regime.tidal_percentage = 0
              expect(described_class.new(regime).calculated_overnight_volume).to be_nil
            end

            context "when draining every 3 cycles" do
              it "sums the full volume of 1,4,7 and the tidal_percentage of 2,3,5,6,8,9" do
                regime.tidal_full_drain_every_three_cycles = true

                overnight_volume = described_class.new(regime).calculated_overnight_volume

                # Fills 1,4,7 follow a complete drain, so are the full `fill_volumne`
                # Fills 2,3,5,6,8,9 are fill_volume * tidal percentage e.g. 0.75
                expect(regime).to be_tidal_full_drain_every_three_cycles
                expected_overnight_volume = (3 * 1500) + (6 * (1500 * 0.80))
                expect(overnight_volume).to eq(expected_overnight_volume)
                expect(overnight_volume).to be_a(Integer)
              end
            end

            context "when not doing a full drain every 3 cycles" do
              it "uses the full fill volume on cycle 1 and the tidal_percentage " \
                 "volume of the remaining cycles" do
                regime.tidal_full_drain_every_three_cycles = false

                overnight_volume = described_class.new(regime).calculated_overnight_volume

                expected_overnight_volume = (1 * 1500) + (8 * (1500 * 0.8))
                expect(overnight_volume).to eq(expected_overnight_volume)
                expect(overnight_volume).to be_a(Integer)
              end
            end
          end
        end
      end
    end
  end
end
