# frozen_string_literal: true

module Renalware
  module PD
    module APD
      describe AvailableOvernightVolume do
        let(:patient) { build(:pd_patient) }
        let(:bag_type) { build(:bag_type, glucose_strength: :medium) }
        let(:regime) do
          reg = build(:apd_regime, no_cycles_per_apd: 7, fill_volume: 1500)
          reg.bags << build(:pd_regime_bag, :weekdays_only, role: :ordinary, volume: 1000)
          reg.bags << build(:pd_regime_bag, :weekdays_only, role: :ordinary, volume: 2000)
          reg
        end

        describe "#value" do
          context "when all days when the patient has PD have the same volume" do
            it "returns the available overnight volume" do
              expect(described_class.new(regime: regime).value).to eq 3000
            end
          end

          context "when all days when the patient has PD do not share the same volume" do
            it "raises an error" do
              # Add a bag which is on weekends only, so now we have 3000 litres Mon to Fri
              # and 2000 litres on Sat and Sun
              regime.bags << build(:pd_regime_bag, :weekend_only, role: :ordinary, volume: 2000)

              expect { described_class.new(regime: regime).value }
                .to raise_error(Renalware::PD::APD::NonUniqueOvernightVolumeError)
            end
          end
        end
      end
    end
  end
end
