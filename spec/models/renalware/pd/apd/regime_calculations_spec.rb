# frozen_string_literal: true

module Renalware
  module PD
    module APD
      class MyRegimeCalculations < RegimeCalculations
        def overnight_volume
          1000
        end
      end

      describe RegimeCalculations do
        let(:regime) do
          reg = build(:apd_regime, no_cycles_per_apd: 7, fill_volume: 1500)
          reg.bags << build(:pd_regime_bag, role: :ordinary)
          reg
        end
        let(:regime_overnight_volume) { 7 * 1500 }

        describe "#daily_volume" do
          it "returns 0 if fill_volume is zero" do
            regime.fill_volume = 0
            expect(NonTidalRegimeCalculations.new(regime).calculated_daily_volume).to be_nil
          end

          it "returns 0 if no_cycles_per_apd is nil" do
            regime.cycles = nil
            expect(NonTidalRegimeCalculations.new(regime).calculated_daily_volume).to be_nil
          end

          it "returns just overnight volume is there is no manual or last exchange" do
            volume = NonTidalRegimeCalculations.new(regime).calculated_daily_volume

            expect(volume).to eq(regime_overnight_volume)
          end

          it "returns overnight volume plus last fill vol plus manual exchange vol if present" do
            regime.bags << build(:pd_regime_bag, role: :last_fill)
            regime.last_fill_volume = 1000

            regime.bags << build(:pd_regime_bag, role: :additional_manual_exchange)
            regime.additional_manual_exchange_volume = 2000
            volume = NonTidalRegimeCalculations.new(regime).calculated_daily_volume

            expect(regime).to have_last_fill_bag
            expect(regime).to be_valid
            expect(volume).to eq(regime_overnight_volume + 1000 + 2000)
          end

          describe "'last fill' bag volume inclusion" do
            context "when bag added and the volume is present" do
              it "includes the volume" do
                regime.bags << build(:pd_regime_bag, role: :last_fill)
                regime.last_fill_volume = 1000

                volume = NonTidalRegimeCalculations.new(regime).calculated_daily_volume

                expect(regime).to have_last_fill_bag
                expect(regime).to be_valid
                expect(volume).to eq(regime_overnight_volume + 1000)
              end
            end

            context "when bag added but volume unset" do
              it "does not includes the volume" do
                regime.bags << build(:pd_regime_bag, role: :last_fill)
                regime.last_fill_volume = nil

                volume = NonTidalRegimeCalculations.new(regime).calculated_daily_volume

                expect(regime).to have_last_fill_bag
                expect(volume).to eq(regime_overnight_volume)
              end
            end

            context "when volume set but no bag added" do
              it "does not includes the volume" do
                regime.last_fill_volume = 2000

                volume = NonTidalRegimeCalculations.new(regime).calculated_daily_volume

                expect(regime).not_to have_last_fill_bag
                expect(volume).to eq(regime_overnight_volume)
              end
            end
          end

          describe "'additional manual exchange' bag volume inclusion" do
            context "when bag added and the volume is present" do
              it "includes the volume" do
                regime.bags << build(:pd_regime_bag, role: :additional_manual_exchange)
                regime.additional_manual_exchange_volume = 2000

                volume = NonTidalRegimeCalculations.new(regime).calculated_daily_volume

                expect(regime).to have_additional_manual_exchange_bag
                expect(regime).to be_valid
                expect(volume).to eq(regime_overnight_volume + 2000)
              end
            end

            context "when bag added but volume unset" do
              it "does not includes the volume" do
                regime.bags << build(:pd_regime_bag, role: :additional_manual_exchange)
                regime.additional_manual_exchange_volume = nil

                volume = NonTidalRegimeCalculations.new(regime).calculated_daily_volume

                expect(regime).to have_additional_manual_exchange_bag
                expect(volume).to eq(regime_overnight_volume)
              end
            end

            context "when volume set but no bag added" do
              it "does not includes the volume" do
                regime.additional_manual_exchange_volume = 2000

                volume = NonTidalRegimeCalculations.new(regime).calculated_daily_volume

                expect(regime).not_to have_additional_manual_exchange_bag
                expect(volume).to eq(regime_overnight_volume)
              end
            end
          end
        end
      end
    end
  end
end
